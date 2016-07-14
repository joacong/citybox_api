module CityboxApi
	# module formany getter utilities
	class Utilities
		def initialize
			raise CityboxApi::INVALID_CREDENTIALS if CityboxApi.configuration.key == nil
	  		@user = CityboxApi.configuration.user
	  		@password = CityboxApi.configuration.key
		end

		# list available cityboxes => 'listarCityboxDisponibles' service
		def list_cityboxes
			server_url = "http://b2b.correos.cl:8008/ServicioCityboxExterno/cch/ws/citybox/externo/implementacion/ServicioCityboxExterno.asmx"
			xml = "<?xml version='1.0' encoding='utf-8'?>
					<soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>
					  <soap:Body>
					    <listarCityboxDisponibles xmlns='http://tempuri.org/'>
					      <usuario>#{@user}</usuario>
					      <contrasena>#{@password}</contrasena>
					    </listarCityboxDisponibles>
					  </soap:Body>
					</soap:Envelope>"

			begin
				xml_response = RestClient.post server_url, xml, content_type: "text/xml"
				json_response = Crack::XML.parse(xml_response)
				json_response["soap:Envelope"]["soap:Body"]["listarCityboxDisponiblesResponse"]["listarCityboxDisponiblesResult"]["CityboxTO"]
			rescue => error
				return CityboxApi.catch_error(error)
			end
		end

		# list master products => 'listarMaestroProductos' service
		def list_master_products
			server_url = "http://b2b.correos.cl:8008/ServicioProductosCorreosExterno/cch/ws/ProductosCorreos/externo/implementacion/ServicioExternoProductoCorreos.asmx"
			xml = "<?xml version='1.0' encoding='utf-8'?>
					<soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>
					  <soap:Body>
					    <listarMaestroProductos xmlns='http://tempuri.org/'>
					      <usuario>#{@user}</usuario>
					      <contrasena>#{@password}</contrasena>
					    </listarMaestroProductos>
					  </soap:Body>
					</soap:Envelope>"

			begin
				xml_response = RestClient.post server_url, xml, content_type: "text/xml"
				json_response = Crack::XML.parse(xml_response)
				json_response["soap:Envelope"]["soap:Body"]["listarMaestroProductosResponse"]["listarMaestroProductosResult"]["ProductoTO"]
			rescue => error
				return CityboxApi.catch_error(error)
			end
		end

		# see scl documents => 'consultaDocumentosSCL' service
		def see_scl_documents shipment_number
			server_url = "http://b2b.correos.cl:8008/ServicioConsultaAvisoDocumentoSCLExterno/cch/ws/externo/implementacion/ServicioExternoConsultaAvisoDocumentoSCL.asmx"
			xml = "<?xml version='1.0' encoding='utf-8'?>
					<soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>
					  <soap:Body>
					    <consultaDocumentosSCL xmlns='http://tempuri.org/'>
					      <usuario>#{@user}</usuario>
					      <contrasena>#{@password}</contrasena>
					      <numeroEnvio>#{shipment_number}</numeroEnvio>
					    </consultaDocumentosSCL>
					  </soap:Body>
					</soap:Envelope>"

			begin
				xml_response = RestClient.post server_url, xml, content_type: "text/xml"
				json_response = Crack::XML.parse(xml_response)
				json_response["soap:Envelope"]["soap:Body"]["consultaDocumentosSCLResponse"]["consultaDocumentosSCLResult"]["DocumentoSclTO"]
			rescue => error
				return CityboxApi.catch_error(error)
			end
		end

		# see fivps => 'consultaFIVPS' service
		def see_fivps shipment_number
			server_url = "http://b2b.correos.cl:8008/ServicioConsultaFivpsExterno/cch/ws/aduana/externo/implementacion/ServicioExternoConsultaFivps.asmx"
			xml = "<?xml version='1.0' encoding='utf-8'?>
					<soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>
					  <soap:Body>
					    <consultaFIVPS xmlns='http://tempuri.org/'>
					      <usuario>#{@user}</usuario>
					      <contrasena>#{@password}</contrasena>
					      <numeroEnvio>#{shipment_number}</numeroEnvio>
					    </consultaFIVPS>
					  </soap:Body>
					</soap:Envelope>"

			begin
				xml_response = RestClient.post server_url, xml, content_type: "text/xml"
				json_response = Crack::XML.parse(xml_response)
				json_response["soap:Envelope"]["soap:Body"]["consultaFIVPSResponse"]["consultaFIVPSResult"]["FivpsTO"]
			rescue => error
				return CityboxApi.catch_error(error)
			end
		end

		# return a hash with normalized address => 'normalizarDireccion' service
		def normalize_address opts={}
			server_url = "http://b2b.correos.cl:8008/ServicioNormalizacionExterno/cch/ws/distribucionGeografica/externo/implementacion/ServicioExternoNormalizacion.asmx"
			# default values
			opts[:request_id] ||= rand(10000)

			# check params
			CityboxApi.check_params [:full_address, :commune], opts

			xml = "<?xml version='1.0' encoding='utf-8'?>
					<soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>
					  <soap:Body>
					    <normalizarDireccion xmlns='http://tempuri.org/'>
					      <usuario>#{@user}</usuario>
					      <contrasena>#{@password}</contrasena>
					      <id>#{opts[:request_id]}</id>
					      <direccion>#{opts[:full_address]}</direccion>
					      <comuna>#{opts[:commune]}</comuna>
					    </normalizarDireccion>
					  </soap:Body>
					</soap:Envelope>"

			begin
				xml_response = RestClient.post server_url, xml, content_type: "text/xml"
				json_response = Crack::XML.parse(xml_response)
				json_response["soap:Envelope"]["soap:Body"]["normalizarDireccionResponse"]["normalizarDireccionResult"]
			rescue => error
				return CityboxApi.catch_error(error)
			end
		end

		# see clain status => 'consultaEstadoDeReclamo' service
		def claim_status claim_number
			server_url = "http://b2b.correos.cl:8008/ServicioEstadoDeReclamosExterno/cch/ws/reclamos/implementacion/ServicioExternoEstadoDeReclamos.asmx"
			xml = "<?xml version='1.0' encoding='utf-8'?>
					<soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>
					  <soap:Body>
					    <consultaEstadoDeReclamo xmlns='http://tempuri.org/'>
					      <usuario>#{@user}</usuario>
					      <contrasena>#{@password}</contrasena>
					      <numero>#{claim_number}</numero>
					    </consultaEstadoDeReclamo>
					  </soap:Body>
					</soap:Envelope>"

			begin
				xml_response = RestClient.post server_url, xml, content_type: "text/xml"
				json_response = Crack::XML.parse(xml_response)
				json_response["soap:Envelope"]["soap:Body"]["consultaEstadoDeReclamoResponse"]["consultaEstadoDeReclamoResult"]
			rescue => error
				return CityboxApi.catch_error(error)
			end
		end
	end
end
