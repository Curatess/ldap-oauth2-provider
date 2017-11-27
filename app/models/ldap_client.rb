class LDAP_Client


  def authenticate(params)
    ldap = Net::LDAP.new
    ldap.encryption(:simple_tls)
    ldap.host = $ldap_settings['ldap_hostname']
    ldap.port = 636
    ldap.auth $ldap_settings['ldap_username'], $ldap_settings['ldap_password']

    login_data = build_login_data(params['username'])

    treebase = generate_ldap_base(ldap.host)
    ldap_filter = build_ldap_filter(login_data)

    authenticated = ldap.bind_as({
        base: treebase,
        filter: ldap_filter,
        password: params['password']
      })

    group_member = true
    if $ldap_settings['ldap_group_cn']
      group_member = false
      ldap.search(base: treebase, filter: ldap_filter) do |entry|
        entry.each do |attribute, values|
          if attribute.match(/memberof/)
            values.each do |value|
              a = value.split(',')
              md = a[0].match(/CN=(.+)/)

              # user is a member of the right group
              if md[1] == $ldap_settings['ldap_group_cn']
                group_member = true
              end
            end
          end
        end
      end
    end

    authenticated && group_member

  end


  def get_data(params)

    data = {}

    ldap = Net::LDAP.new
    ldap.encryption(:simple_tls)
    ldap.host = $ldap_settings['ldap_hostname']
    ldap.port = 636
    ldap.auth $ldap_settings['ldap_username'], $ldap_settings['ldap_password']

    login_data = build_login_data(params['username'])
    attrs = [
      'employeeid',
      'name',
      'mail',
      'telephonenumber',
      'title',
      'distinguishedname',
      'memberof',
      'samaccountname'
    ]

    options = {
      base: generate_ldap_base(ldap.host),
      filter: build_ldap_filter(login_data),
      attributes: attrs
    }

    ldap.search(options) do |entry|
      entry.each do |attr, value|
        data[attr] = value
      end
    end

    data

  end


  private


    def build_login_data(login_name)
      login_data = {}
      if login_name.include?('@')
        login_data['mail'] = login_name
        login_data['userPrincipalName'] = login_name
        login_data['sAMAccountName'] = convert_email_to_username(login_name)
      elsif login_name.include?("\\")
        login_data['mail'] = convert_downlevel_to_email(login_name)
        login_data['userPrincipalName'] = convert_downlevel_to_email(login_name)
        login_data['sAMAccountName'] = convert_downlevel_to_username(login_name)
      else
        login_data['mail'] = convert_username_to_email(login_name)
        login_data['userPrincipalName'] = convert_username_to_email(login_name)
        login_data['sAMAccountName'] = login_name
      end
      login_data
    end


    def convert_email_to_username(email)
      email.partition('@')[0]
    end


    def convert_downlevel_to_email(downlevel)
      email_start = convert_downlevel_to_username(downlevel)
      email_end = generate_email_end_from_host_name
      email_start + "@" + email_end
    end


    def convert_downlevel_to_username(downlevel)
      downlevel.partition('\\')[2]
    end


    def convert_username_to_email(username)
      username + "@" + generate_email_end_from_host_name
    end


    def generate_email_end_from_host_name
      $ldap_settings['ldap_hostname'].partition('.')[2]
    end


    def build_ldap_filter(login_data)
      filter = '(|'
      login_data.each do |key, value|
        filter += '(' + key + '=' + value + ')'
      end
      filter += ')'
    end
    # The Output Schema We Want
    #"(|(mail=#{login_data[:email]})(userPrincipalName=#{login_data[:upn]})(sAMAccountName=#{login_data[:saman]}))"


    def generate_ldap_base(host)
      host.split('.')[1..-1].inject('') { |base, domain| base + 'DC=' + domain + ',' }.chop
    end


end
