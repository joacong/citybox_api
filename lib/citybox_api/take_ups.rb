module CityboxApi
	# module for take ups services
	class TakeUps
		def initialize
			raise CityboxApi::INVALID_CREDENTIALS if CityboxApi.configuration.key == nil
	  		@user = CityboxApi.configuration.user
	  		@password = CityboxApi.configuration.key
	  		@server_url = "http://b2b.correos.cl:8008/ServicioRetiroEnvioExterno/cch/ws/retirosCEP/externo/implementacion/ServicioExternoRetiro.asmx"
		end

		# send a register take up request => 'reistrarRetiro' service
		def register opts={}
			# default values
			opts[:sender_country] ||= "056"

			# check params
			CityboxApi.check_params [ :admission_code, :sender_code, :sender_contact_person, :sender_contact_phone, :take_up_date,
									  :take_up_from_hour, :take_up_to_hour ], opts

			# format for date: aaaa-mm-dd
			xml = "<?xml version='1.0' encoding='utf-8'?>
					<soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>
					  <soap:Body>
					    <registrarRetiro xmlns='http://tempuri.org/'>
					      <usuario>#{@user}</usuario>
					      <contrasena>#{@password}</contrasena>
					      <retiroTO>
					        <ExtensionData />
					        <CodigoAdmision>#{opts[:admission_code]}</CodigoAdmision>
					        <ClienteRemitente>#{opts[:sender_code]}</ClienteRemitente>
					        <CentroRemitente></CentroRemitente>
					        <NombreRemitente>#{opts[:sender_name]}</NombreRemitente>
					        <DireccionRemitente>#{opts[:sender_address]}</DireccionRemitente>
					        <PaisRemitente>#{opts[:sender_country]}</PaisRemitente>
					        <CodigoPostalRemitente>#{opts[:sender_postal_code]}</CodigoPostalRemitente>
					        <ComunaRemitente>#{opts[:sender_commune]}</ComunaRemitente>
					        <RutRemitente>#{opts[:sender_rut]}</RutRemitente>
					        <PersonaContactoRemitente>#{opts[:sender_contact_person]}</PersonaContactoRemitente>
					        <TelefonoContactoRemitente>#{opts[:sender_contact_phone]}</TelefonoContactoRemitente>
					        <FechaRetiro>#{opts[:take_up_date]}</FechaRetiro>
					        <HoraDesde>#{opts[:take_up_from_hour]}</HoraDesde>
					        <HoraHasta>#{opts[:take_up_to_hour]}</HoraHasta>
					      </retiroTO>
					    </registrarRetiro>
					  </soap:Body>
					</soap:Envelope>"

			begin
				xml_response = RestClient.post @server_url, xml, content_type: "text/xml"
				json_response = Crack::XML.parse(xml_response)
				json_response["soap:Envelope"]["soap:Body"]["registrarRetiroResponse"]["registrarRetiroResult"]
			rescue => error
				return CityboxApi.catch_error(error)
			end
		end
	end
end