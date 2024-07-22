using Microsoft.AspNetCore.Http;

namespace DMNSN.AspNetCore.Middlewares.CorrelationId
{
    public class CorrelationIdMiddleware
    {
        private readonly RequestDelegate next;
        private readonly CorrelationIdMiddlewareOptions options;

        public CorrelationIdMiddleware(RequestDelegate _next, CorrelationIdMiddlewareOptions _options)
        {
            next = _next;
            options = _options ?? throw new ArgumentNullException(nameof(options));
        }
        public async Task InvokeAsync(HttpContext context)
        {
            if (options.EnableFeature)
            {
                var correlationId = context.Request.Headers[options.CorrelationKey];
                if (string.IsNullOrEmpty(correlationId))
                {
                    correlationId = Guid.NewGuid().ToString("N");
                    context.Request.Headers.TryAdd(options.CorrelationKey, correlationId);
                }
                context.Response.Headers.TryAdd(options.CorrelationKey, correlationId);
            }

            await next(context);
        }
    }
}
