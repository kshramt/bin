# LICENSE: GPL v3
module DataParse
  module Cmtsolution
    ParseError = Class.new(StandardError)

    module_function

    def preprocess_for_parse(text_for_one_event)
      text_for_one_event\
        .sub(/\A\n*/, '')\
        .sub(/\n*\z/, '')\
        .split("\n")
    end

    def parse_lines(lines)
      h = {hypocenter: {}, centroid: {}}

      line0 = lines[0]
      h[:hypocenter][:data_source] = line0[0..4].strip
      line0_rest = line0[5..-1].split
      [:year, :month, :day, :hour, :minute].each{|k|
        raise ParseError if line0_rest.empty?
        h[:hypocenter][k] = line0_rest.shift.to_i
      }
      [:second, :latitude, :longitude, :depth, :mb, :ms].each{|k|
        raise ParseError if line0_rest.empty?
        h[:hypocenter][k] = line0_rest.shift.to_f
      }
      h[:hypocenter][:region_name] = line0_rest.join(' ')
      h[:event_name] = lines[1].split(':')[1].strip
      values = lines[2..-1].map{|line| line.split(':')[1].to_f}
      [
       :time_shift, :half_duration,
       :latitude, :longitude, :depth,
       :mrr, :mtt, :mpp, :mrt, :mrp, :mtp,
      ].zip(values).each{|k, v| h[:centroid][k] = v}

      h
    end

    def parse(text_for_one_event)
      begin
        lines = preprocess_for_parse(text_for_one_event)
        parse_lines(lines)
      rescue
        raise ParseError, text_for_one_event\
          .split("\n")\
          .map{|line| "|#{line}|"}\
          .join("\n")
      end
    end
  end
end

module GcmtScrape
  require 'mechanize'

  class MyParserForBadHtmlOfGcmtCatalog < ::Mechanize::Page
    def initialize(uri = nil, response = nil, body = nil, code = nil, mech = nil)
      super(uri, response, body.gsub(/<=/, '&lt;='), code, mech)
    end
  end

  module_function

  def scrape(url)
    agent = Mechanize.new{|a|
      a.pluggable_parser.html = ::GcmtScrape::MyParserForBadHtmlOfGcmtCatalog
    }

    event_list = []
    while url
      agent.get(url)
      agent.page.search('pre')\
        .find{|e| e.text =~ /event name:/}\
        .text.split("\n\n")\
        .each{|event|
        begin
          event_list << ::DataParse::Cmtsolution.parse(event) unless event.strip.empty?
        rescue ::DataParse::Cmtsolution::ParseError => e
          $stderr.puts e.class
          $stderr.puts e.message
        end
      }

      url = nil
      if next_link = agent.page.links\
          .find{|e| e.text == 'More solutions'}
        url = next_link.uri
      end

      sleep 5
    end

    event_list
  end
end


if __FILE__ == $PROGRAM_NAME

  raise <<-EOS unless ARGV[0]
Specify url.

$ ruby1.9 gcmt_scrape.rb http://abc.def

  EOS

  event_list = GcmtScrape.scrape(ARGV[0])

  # Please modify following code.
  require 'yaml'
  puts YAML.dump(event_list)
end
