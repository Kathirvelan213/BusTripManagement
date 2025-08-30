using Microsoft.AspNetCore.SignalR;

namespace BusTripManagement.API.Hubs
{
    public class LiveLocationHub:Hub
    {
        public override async Task OnConnectedAsync()
        {
            await Clients.Caller.SendAsync("receiveAcknowledgement",null);
        }
        public async Task BusLocationToClients(double latitude, double longitude)
        {
            Console.WriteLine(latitude.ToString() + longitude.ToString());
            await Clients.All.SendAsync("receiveLocationUpdate", latitude, longitude);
        }
    }
}
