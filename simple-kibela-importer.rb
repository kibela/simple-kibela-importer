require 'net/http'
require 'json'
require 'pathname'

TEAM = ENV.fetch('TEAM')
TOKEN = ENV.fetch('KIBELA_ACCESS_TOKEN')
APPLY = ENV['APPLY']

def req(query)
  http = Net::HTTP.new("#{TEAM}.kibe.la", 443)
  http.use_ssl = true
  header = {
    "Authorization" => "Bearer #{TOKEN}",
    'Content-Type' => 'application/json',
    'User-Agent' => 'Simple Kibela Importer',
  }
  resp = http.request_post('/api/v1', JSON.generate(query), header)
  JSON.parse(resp.body, symbolize_names: true).tap do |content|
    raise content[:errors].inspect if content[:errors]
  end
end

def default_group_id
  @default_group_id ||= begin
    req({
      query: <<~GRAPHQL,
        query {
          defaultGroup {
            id
          }
        }
      GRAPHQL
    })[:data][:defaultGroup][:id]
  end
end

def dry_run_tag
  APPLY ? '' : '[DRY RUN] '
end

def process(path)
  print "#{dry_run_tag}Importing #{path}... "
  unless APPLY
    puts
    return
  end

  title = path.basename('.md')
  content = path.read

  resp = req({
    query: <<~GRAPHQL,
      mutation($title: String!, $content: String!, $coediting: Boolean!, $groupIds: [ID!]!) {
        createNote(input: { title: $title, content: $content, coediting: $coediting, groupIds: $groupIds }) {
          note {
            url
          }
        }
      }
    GRAPHQL
    variables: {
      title: title,
      content: content,
      coediting: true,
      groupIds: [default_group_id],
    },
  })
  puts "#{resp[:data][:createNote][:note][:url]}"
end

def main(argv)
  if argv.empty?
    puts <<~HELP
      Usage:
        ruby import-kibela path/to/md [path/to/other/md]
    HELP
    return
  end

  n = 0
  argv.each do |arg|
    arg = Pathname(arg)
    if arg.fnmatch('*.md')
      process(arg)
      n += 1
    end
    arg.glob('**/*.md') do |path|
      process(path)
      n += 1
    end
  end

  if APPLY
    puts "It imported #{n} files to #{TEAM}.kibe.la."
  else
    puts "#{dry_run_tag}It will import #{n} files to #{TEAM}.kibe.la if you execute this with `APPLY=1` environment variable."
  end
end

main(ARGV)
