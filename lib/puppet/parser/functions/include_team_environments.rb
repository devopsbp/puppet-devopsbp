require 'octokit'

module Puppet::Parser::Functions
  newfunction(:include_team_environments) do |arguments|
    unless arguments.length == 1
      raise Puppet::ParseError, "Must provide exactly one arg to include_team_environments"
    end

    Puppet::Parser::Functions.function('include')

    api = Octokit::Client.new :access_token => Facter[:github_token].value
    org = arguments[0]

    teams = api.org_teams(org)
    teams.each do |team|
      klass = "#{org}::environment::#{team.slug}"
      path = "#{Facter[:boxen_repodir].value}/modules/#{org}/manifests/environment/#{team.slug}.pp"

      next if team.slug =~ /^owners$/

      if api.team_member?(team.id, Facter[:github_login].value)
        if File.exist?(path)
          function_include [klass]
        else
          warning "Don't know anything about '#{klass}'. Help out by defining it at '#{path}'."
        end
      end
    end
  end
end
