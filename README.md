# CityboxApi

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/citybox_api`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'citybox_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install citybox_api

## Usage
This is a Ruby wrapper for Citybox SOAP API

Configure CityboxApi

	CityboxApi.configure do |config|
		config.user  = your_user
		config.key = your_password
	end

In this version of citybox_api gem you can user 2 API services:
* Regions Services
* Branch Offices Services

- Regions Services:

	@regions_services = CityboxApi::Regions.new
	
	@regions_services.list_regions # return a list with all availables regions
	@regions_services.list_comunes # return a list with all availables communes
	@regions_services.list_comunes_by_region(region_id) # return a list with all availables communes for region with id 'region_id'

- Branch Offices Services
	
	@branch_offices_services = CityboxApi::BranchOffices.new
	
	@branch_offices_services.list_branch_offices # return a list with all availables branch offices
	@branch_offices_services.list_branch_offices_by_commune(commune_id) # return a list with all availables branch offices for commue with id 'commune_id'
	@branch_offices_services.list_branch_offices_near_to(street_name: '', street_number: '', commune_name: '') # return a list with all  availables branch offices near to especific location

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/citybox_api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

