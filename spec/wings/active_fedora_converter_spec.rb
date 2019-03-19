# frozen_string_literal: true
require 'spec_helper'
require 'wings'
require 'wings/active_fedora_converter'

RSpec.describe Wings::ActiveFedoraConverter do
  subject(:converter) { described_class.new(resource: resource) }
  let(:adapter)       { Valkyrie::Persistence::Memory::MetadataAdapter.new }
  let(:attributes)    { { id: id } }
  let(:id)            { 'moomin_id' }
  let(:resource)      { work.valkyrie_resource }
  let(:work)          { GenericWork.new(attributes) }

  describe '#convert' do
    it 'returns the ActiveFedora model' do
      expect(converter.convert).to eq work
    end

    context 'with attributes' do
      let(:attributes) do
        FactoryBot.attributes_for(:generic_work)
      end

      it 'repopulates the attributes' do
        expect(converter.convert).to have_attributes(attributes)
      end

      it 'populates reflections'
    end

    context 'with an embargo' do
      let(:work) { FactoryBot.create(:embargoed_work) }

      it 'repopulates the embargo' do
        expect(converter.convert).to have_attributes(embargo_id: work.embargo_id)
      end
    end

    context 'with a lease' do
      let(:work) { FactoryBot.create(:leased_work) }

      it 'repopulates the lease' do
        expect(converter.convert).to have_attributes(lease_id: work.lease_id)
      end
    end
  end
end