RSpec::Matchers.define :response_schema do |schema|
    match do |response|
      schema_directory = "#{Dir.pwd}/spec/support/schemas"
      schema_path = "#{schema_directory}/#{schema}.json"
      JSON::Validator.validate!(schema_path, response.body, strict: true)
    end
end