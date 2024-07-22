using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Configuration;

namespace DMNSN.AspNetCore.Middlewares.CorrelationId
{
    public static class CorrelationIdMiddlewareExtensions
    {
        private const string DefaultSection = "DMNSN:Middlewares:CorrelationId";
        public static IApplicationBuilder UseCorrelationIdMiddleware(this IApplicationBuilder builder, IConfiguration configuration)
        {
            // Attempt to read the configuration section
            var options = configuration.GetSection(DefaultSection).Get<CorrelationIdMiddlewareOptions>() ?? new CorrelationIdMiddlewareOptions();
            return builder.UseMiddleware<CorrelationIdMiddleware>(options);
        }
        public static IApplicationBuilder UseCorrelationIdMiddleware(this IApplicationBuilder builder, CorrelationIdMiddlewareOptions options)
        {
            return builder.UseMiddleware<CorrelationIdMiddleware>(options);
        }
    }
}
