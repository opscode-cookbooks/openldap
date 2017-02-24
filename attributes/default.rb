# Cookbook:: openldap
# Attributes:: default
#
# Copyright:: 2008-2016, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# per platform settings (generally not overwritten by the user)
#

# File and directory locations for openldap.
case node['platform_family']
when 'rhel'
  default['openldap']['dir'] = '/etc/openldap'
  default['openldap']['run_dir'] = '/var/run/openldap'
  default['openldap']['db_dir'] = '/var/lib/ldap'
  default['openldap']['module_dir'] = '/usr/lib64/openldap'
  default['openldap']['system_acct'] = 'ldap'
  default['openldap']['system_group'] = 'ldap'
when 'debian'
  default['openldap']['dir'] = '/etc/ldap'
  default['openldap']['run_dir'] = '/var/run/slapd'
  default['openldap']['db_dir'] = '/var/lib/ldap'
  default['openldap']['module_dir'] = '/usr/lib/ldap'
  default['openldap']['system_acct'] = 'openldap'
  default['openldap']['system_group'] = 'openldap'
when 'freebsd'
  default['openldap']['dir'] = '/usr/local/etc/openldap'
  default['openldap']['run_dir'] = '/var/run/openldap'
  default['openldap']['db_dir'] = '/var/db/openldap-data'
  default['openldap']['module_dir'] = '/usr/local/libexec/openldap'
  default['openldap']['system_acct'] = 'ldap'
  default['openldap']['system_group'] = 'ldap'
end

# backing database
case node['platform_family']
when 'freebsd'
  default['openldap']['modules'] = %w(back_mdb)
  default['openldap']['database'] = 'mdb'
else
  default['openldap']['modules'] = %w(back_hdb)
  default['openldap']['database'] = 'hdb'
end

# package settings
default['openldap']['package_install_action'] = :install

#
# openldap configuration attributes (generally overwritten by the user)
#

default['openldap']['basedn'] = 'dc=localdomain'
default['openldap']['cn'] = 'admin'
default['openldap']['server'] = 'ldap.localdomain'
default['openldap']['tls_enabled'] = true

unless node['domain'].nil? || node['domain'].split('.').count < 2
  default['openldap']['basedn'] = "dc=#{node['domain'].split('.').join(',dc=')}"
  default['openldap']['server'] = "ldap.#{node['domain']}"
end

default['openldap']['rootpw'] = nil
default['openldap']['preseed_dir'] = '/var/cache/local/preseeding'
default['openldap']['loglevel'] = 'sync config'
default['openldap']['schemas'] = %w(core.schema cosine.schema nis.schema inetorgperson.schema)

default['openldap']['manage_ssl'] = false
default['openldap']['tls_checkpeer'] = false
default['openldap']['ssl_dir'] = "#{node['openldap']['dir']}/ssl"
default['openldap']['cafile']  = nil
default['openldap']['ssl_cert'] = "#{node['openldap']['ssl_dir']}/#{node['openldap']['server']}_cert.pem"
default['openldap']['ssl_key'] = "#{node['openldap']['ssl_dir']}/#{node['openldap']['server']}.pem"
default['openldap']['ssl_cert_source_cookbook'] = 'openldap'
default['openldap']['ssl_cert_source_path'] = "ssl/#{node['openldap']['server']}_cert.pem"
default['openldap']['ssl_key_source_cookbook'] = 'openldap'
default['openldap']['ssl_key_source_path'] = "ssl/#{node['openldap']['server']}.pem"

default['openldap']['slapd_type'] = nil

# syncrepl slave syncing attributes
default['openldap']['slapd_master'] = node['openldap']['server']
default['openldap']['slapd_replpw'] = nil
default['openldap']['slapd_rid'] = 102
default['openldap']['syncrepl_interval'] = '01:00:00:00'
default['openldap']['syncrepl_type'] = 'refreshAndPersist'
default['openldap']['syncrepl_filter'] = '(objectClass=*)'
default['openldap']['syncrepl_use_tls'] = 'no' # yes or no
default['openldap']['syncrepl_dn'] = "cn=syncrole,#{node['openldap']['basedn']}"

# These the config hashes are dynamically parsed into the slapd.config and ldap.config files
# You can add to the hashes in wrapper cookbooks to add your own config options via wrapper cokbooks
# see readme for usage information

# The maximum number of entries that is returned for a search operation
default['openldap']['server_config_hash']['sizelimit'] = 500
