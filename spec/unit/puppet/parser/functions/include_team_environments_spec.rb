#!/usr/bin/env ruby
require 'spec_helper'

describe Puppet::Parser::Functions.function(:include_team_environments) do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it 'should exist' do
    Puppet::Parser::Functions.function('include_team_environments').should == 'function_include_team_environments'
  end

  it 'should only allow one argument' do
    expect {
      scope.function_include_team_environments([])
    }.to raise_error(Puppet::ParseError, /Must provide exactly one arg to include_team_environments/)

    expect {
      scope.function_include_team_environments(['1', '2', '3'])
    }.to raise_error(Puppet::ParseError, /Must provide exactly one arg to include_team_environments/)
  end
end
