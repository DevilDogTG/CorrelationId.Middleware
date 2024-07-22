namespace DMNSN.AspNetCore.Middlewares.CorrelationId
{
    public class CorrelationIdMiddlewareOptions
    {
        public bool EnableFeature { get; set; } = true;
        public string CorrelationKey { get; set; } = "X-Correlation-ID";
    }
}
