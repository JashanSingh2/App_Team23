import React from 'react';
import { ServiceProvider } from '@/types/types';

interface RideCardProps {
  provider: ServiceProvider;
  onBook?: () => void;
}

export const RideCard: React.FC<RideCardProps> = ({ provider, onBook }) => {
  return (
    <div className="border rounded-lg p-4 shadow-sm">
      <h3 className="text-lg font-semibold">{provider.name}</h3>
      <div className="mt-2">
        <p>Vehicle: {provider.vehicleModel} ({provider.vehicleNumber})</p>
        <p>Type: {provider.vehicleType}</p>
        <p>Facility: {provider.facility}</p>
        <p>Seats: {provider.maxSeats}</p>
        <p>Fare: ₹{provider.fare}</p>
        <p>Rating: {provider.rating}/5</p>
      </div>
      {onBook && (
        <button
          onClick={onBook}
          className="mt-4 bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600"
        >
          Book Ride
        </button>
      )}
    </div>
  );
}; 