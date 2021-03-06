require 'airport'
require 'plane'

describe Airport do
  let(:airport) { described_class.new }
  let(:plane) { described_class.new }
  let(:weather) { described_class.new }

  it { is_expected.to respond_to(:instruct_plane_land) }
  it { is_expected.to respond_to(:instruct_plane_take_off) }

  describe '#Hangar' do
    it 'Hangar default capacity can be changed' do
      allow(airport).to receive(:capacity).and_return(20)
      expect(airport.capacity).to eq 20
    end

    it 'counts how many planes are in hangar' do
      10.times { airport.instruct_plane_land(plane) }
      expect(airport.planes_count).to eq 10
    end

    it 'counts how many planes are in hangar after two plane takes off' do
      10.times { airport.instruct_plane_land(plane) }
      2.times { airport.instruct_plane_take_off(plane) }
      expect(airport.planes_count).to eq 8
    end

  end

  describe '#instruct_plane_land' do
    it 'instructs plane to land and confirms it landed' do
      allow(airport).to receive(:bad_weather?).and_return(false)
      expect(airport.instruct_plane_land(plane)).to eq "#{plane} has landed"
    end

    it 'Will prevent landing when weather is stormy' do
      allow(airport).to receive(:bad_weather?).and_return(true)
      expect{ airport.instruct_plane_land(plane) }.to raise_error "Weather is not good, #{plane} cannot land"
    end

    it 'plane cannot land if hangar is already full' do
      15.times { airport.instruct_plane_land(plane) }
      expect{ airport.instruct_plane_land(plane) }.to raise_error "Hangar is full, #{plane} not able to land"
    end

    it 'Depending on the weather it will allow or deny landing' do
      if :bad_weather? == true
        expect{ airport.instruct_plane_land(plane) }.to raise_error "Weather is not good, #{plane} cannot land"
      else
        expect(airport.instruct_plane_land(plane)).to eq "#{plane} has landed"
      end
    end
  end

  describe '#instruct_plane_take_off' do
    it 'instructs plane to take off and confirms plane has left airport' do
      allow(subject).to receive(:bad_weather?) { false }
      airport.instruct_plane_land(plane)
      expect(airport.instruct_plane_take_off(plane)).to eq "#{plane} has left airport"
    end

    it 'Depending on the weather it will allow or deny take off' do
      airport.instruct_plane_land(plane)
      if :bad_weather? == true
        expect{ airport.instruct_plane_take_off(plane) }.to raise_error "Weather is not good, #{plane} cannot take off"
      else
        expect(airport.instruct_plane_take_off(plane)).to eq "#{plane} has left airport"
      end
    end

    it 'plane cannot take off if hangar is empty' do
      expect{ airport.instruct_plane_take_off([]) }.to raise_error "Hangar is empty, no plane to take off"
    end

    it 'Will prevent takeoff when weather is stormy' do
      airport.instruct_plane_land(plane)
      allow(airport).to receive(:bad_weather?).and_return(true)
      expect{ airport.instruct_plane_take_off(plane) }.to raise_error "Weather is not good, #{plane} cannot take off"
    end
  end
end
