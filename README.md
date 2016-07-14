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

In this version of citybox_api gem you can use 20 API services:

- Regions Services:

	@regions_services = CityboxApi::Regions.new
	
	1) @regions_services.list_regions # return a list with all availables regions
	
	2) @regions_services.list_comunes # return a list with all availables communes
	
	3) @regions_services.list_comunes_by_region(region_id) # return a list with all availables communes for region with id 'region_id'

- Branch Offices Services
	
	@branch_offices_services = CityboxApi::BranchOffices.new
	
	4) @branch_offices_services.list_branch_offices # return a list with all availables branch offices
	
	5) @branch_offices_services.list_branch_offices_by_commune(commune_id) # return a list with all availables branch offices for commue with id 'commune_id'
	
	6) @branch_offices_services.list_branch_offices_near_to(street_name: '', street_number: '', commune_name: '') # return a list with all  availables branch offices near to especific location

- Shipments
	
	@shipments = CityboxApi::Shipments.new
	
	7) @shipments.allow_shipment # sent an allow shipping request => 'admitirEnvio' Service
	
	8) @shipments.validate_shipment # send a validate shipment request => 'validarEnvio' service
	
	9) @shipments.cancel_shipment # send a cancel shipment request => 'anularEnvio' service

- Take ups
	
	@take_ups = CityboxApi::TakeUps.new
	
	10) @take_ups.register # send a register take up request => 'reistrarRetiro' service

- Tariff
	
	@tariff = CityboxApi::Tariff.new
	
	11) @tariff.apply_tariff_to_person # send an apply tariff to person request => 'aplicarTarifaPersona' service
	
	12) @tariff.see_scope # see scope => 'consultarCobertura' service
	
	13) @tariff.see_scope_by_product # see scope by product => 'consultarCoberturaPorProducto' service
	
	14) @tariff.see_products_by_client # see products by client => 'consultaProductosPorCliente' service

- Utilities
	
	@utilities = CityboxApi::Utilities.new
	
	15) @utilities.list_cityboxes # list available cityboxes => 'listarCityboxDisponibles' service
	
	16) @utilities.list_master_products # list master products => 'listarMaestroProductos' service
	
	17) @utilities.see_scl_documents # see scl documents => 'consultaDocumentosSCL' service
	
	18) @utilities.see_fivps # see fivps => 'consultaFIVPS' service
	
	19) @utilities.normalize_address # return a hash with normalized address => 'normalizarDireccion' service
	
	20) @utilities.claim_status # see clain status => 'consultaEstadoDeReclamo' service










## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/citybox_api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

