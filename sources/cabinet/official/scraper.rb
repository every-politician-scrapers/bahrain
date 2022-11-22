#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    field :name do
      noko.text.tidy.gsub(/^H\.E\.\s+/, '')
    end

    field :position do
      noko.xpath('following-sibling::text()').first.text.tidy.gsub(/\.$/, '').split(/ and (?=Minister|Prime)/).map(&:tidy)
    end

    def skip?
      position.to_s.empty?
    end

    private

    def name_and_position
      noko.css('a').text.split('-', 2).map(&:tidy)
    end
  end

  class Members
    def member_container
      noko.css('.expand_content strong')
    end

    def member_items
      super.reject(&:skip?)
    end
  end
end

file = Pathname.new 'official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
