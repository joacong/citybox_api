module CityboxApi
	# module for branch offices services
	class BranchOffices
		def initialize
			raise CityboxApi::INVALID_CREDENTIALS if CityboxApi.configuration.key == nil
			@server_url = "http://b2b.correos.cl:8008/ServicioListadoSucursalesExterno/cch/ws/distribucionGeografica/implementacion/ServicioExternoListarSucursales.asmx"
	  		@user = CityboxApi.configuration.user
	  		@password = CityboxApi.configuration.key
		end
		# list all branch offices
		def list_branch_offices
			xml = "<?xml version='1.0' encoding='utf-8'?>
					<soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>
					  <soap:Body>
					    <listarTodasLasSucursales xmlns='http://tempuri.org/'>
					      <usuario>#{@user}</usuario>
					      <contrasena>#{@password}</contrasena>
					    </listarTodasLasSucursales>
					  </soap:Body>
					</soap:Envelope>"

			begin
				xml_response = RestClient.post @server_url, xml, content_type: "text/xml"
				json_response = Crack::XML.parse(xml_response)
				json_response["soap:Envelope"]["soap:Body"]["listarTodasLasSucursalesResponse"]["listarTodasLasSucursalesResult"]["SucursalTO"]
			rescue => error
				json_response = Crack::XML.parse(error.response)
				fault_code = json_response["soap:Envelope"]["soap:Body"]["soap:Fault"]["faultcode"]
				fault_string = json_response["soap:Envelope"]["soap:Body"]["soap:Fault"]["faultstring"]
				fault = {faultCode: fault_code, fault_string: fault_string}
				puts fault
				return nil
			end
		end

		# list all branch offices for commune with id 'commune_id'
		def list_branch_offices_by_commune commune_id
			xml = "<?xml version='1.0' encoding='utf-8'?>
					<soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>
					  <soap:Body>
					    <listarSucursalesSegunComuna xmlns='http://tempuri.org/'>
					      <usuario>#{@user}</usuario>
					      <contrasena>#{@password}</contrasena>
					      <codigoComuna>#{commune_id}</codigoComuna>
					    </listarSucursalesSegunComuna>
					  </soap:Body>
					</soap:Envelope>"

			begin
				xml_response = RestClient.post @server_url, xml, content_type: "text/xml"
				json_response = Crack::XML.parse(xml_response)
				json_response["soap:Envelope"]["soap:Body"]["listarSucursalesSegunComunaResponse"]["listarSucursalesSegunComunaResult"]["SucursalTO"]
			rescue => error
				json_response = Crack::XML.parse(error.response)
				fault_code = json_response["soap:Envelope"]["soap:Body"]["soap:Fault"]["faultcode"]
				fault_string = json_response["soap:Envelope"]["soap:Body"]["soap:Fault"]["faultstring"]
				fault = {faultCode: fault_code, fault_string: fault_string}
				puts fault
				return nil
			end
		end

		# list all branch offices near to a especific location
		def list_branch_offices_near_to opts={}
			request_id = rand(10000)
			xml = "<?xml version='1.0' encoding='utf-8'?>
					<soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>
					  <soap:Body>
					    <consultaSucursalMasCercana xmlns='http://tempuri.org/'>
					      <usuario>#{@user}</usuario>
					      <contrasena>#{@password}</contrasena>
					      <id>#{request_id}</id>
					      <nombreCalle>#{opts[:street_name]}</nombreCalle>
					      <numeroCalle>#{opts[:street_number]}</numeroCalle>
					      <restoCalle>#{opts[:street_detail]}</restoCalle>
					      <NombreComuna>#{opts[:commune_name]}</NombreComuna>
					      <latitud>#{opts[:latitude]}</latitud>
					      <longitud>#{opts[:longitude]}</longitud>
					    </consultaSucursalMasCercana>
					  </soap:Body>
					</soap:Envelope>"

			begin
				xml_response = RestClient.post @server_url, xml, content_type: "text/xml"
				json_response = Crack::XML.parse(xml_response)
				json_response["soap:Envelope"]["soap:Body"]["consultaSucursalMasCercanaResponse"]["consultaSucursalMasCercanaResult"]
			rescue => error
				json_response = Crack::XML.parse(error.response)
				fault_code = json_response["soap:Envelope"]["soap:Body"]["soap:Fault"]["faultcode"]
				fault_string = json_response["soap:Envelope"]["soap:Body"]["soap:Fault"]["faultstring"]
				fault = {faultCode: fault_code, fault_string: fault_string}
				puts fault
				return nil
			end
		end
	end
end