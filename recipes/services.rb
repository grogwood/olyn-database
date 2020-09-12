# MySQL service definition
service 'mysql' do
  supports restart: true
  action :nothing
end
