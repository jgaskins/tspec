require_relative '../lib/tspec/description'

module TSpec
  describe Description do
    let(:description) { Description.new('foo') {} }
    let(:attribute) { :parent }

    it 'has a title' do
      expect(description.title).to eq 'foo'
    end

    describe 'attributes' do
      let(:description) { Description.new('') { let(:foo) { 'bar' } } }

      it 'defines attributes with let blocks' do
        attribute = description.attributes.first
        expect(attribute.name).to eq :foo
      end

      it 'adds attributes to child descriptions' do
        expect(attribute).to eq :parent
      end

      describe 'overwriting parent attributes' do
        let(:attribute) { :child }

        it 'uses the innermost let block to define its attributes' do
          expect(attribute).to eq :child
        end
      end
    end
  end
end
