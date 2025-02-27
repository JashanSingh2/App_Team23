// Define TypeScript interfaces
export interface ServiceProvider {
  id: number;
  name: string;
  vehicleNumber: string;
  vehicleModel: string;
  vehicleType: 'bus' | 'car';
  facility: 'ac' | 'nonAc';
  maxSeats: number;
  fare: number;
  rating: number;
}

export interface RideAvailable {
  id: number;
  date: string;
  seatsAvailable: number;
  serviceProvider: string;
  service_provider?: ServiceProvider;
}

export interface RideHistory {
  id: number;
  source: string;
  destination: string;
  date: string;
  serviceProvider: string;
  fare: number;
  seatNumber: number | null;
  service_provider?: ServiceProvider;
} 