# frozen_string_literal: true

require 'spec_helper'

describe 'docker::env' do
  it { is_expected.to run.with_params([4]).and_return([4]) }
  it { is_expected.to run.with_params([4, 5, '3']).and_return([4, 5, '3']) }
  it { is_expected.to run.with_params(2).and_raise_error(StandardError) }
  it { is_expected.to run.with_params('string').and_raise_error(StandardError) }
  it { is_expected.to run.with_params(nil).and_raise_error(StandardError) }
end
