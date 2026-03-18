using System;
using System.Configuration;
using System.Web;

namespace MachSoft.PrivateNuGetFeed.Web.Models
{
    public class PortalSettings
    {
        private const string DefaultBaseUrlPlaceholder = "https://__APP_SERVICE_URL__";
        private const string DefaultApiKeyPlaceholder = "__API_KEY__";
        private const string DefaultPortalVersion = "v1.0.0";
        private const string DefaultPackageRepositoryPath = "~/App_Data/Packages";

        public string PublicPortalUrl { get; private set; }

        public string FeedUrl { get; private set; }

        public string PushApiKeyPlaceholder { get; private set; }

        public string PortalVersion { get; private set; }

        public string PackageRepositoryPath { get; private set; }

        public static PortalSettings FromRequest(HttpRequestBase request)
        {
            var baseUrl = GetConfiguredValue("PortalBaseUrl");
            if ((string.IsNullOrWhiteSpace(baseUrl) || baseUrl.IndexOf("__APP_SERVICE_URL__", StringComparison.OrdinalIgnoreCase) >= 0) && request?.Url != null)
            {
                baseUrl = request.Url.GetLeftPart(UriPartial.Authority) + VirtualPathUtility.ToAbsolute("~/").TrimEnd('/');
            }

            baseUrl = string.IsNullOrWhiteSpace(baseUrl) ? DefaultBaseUrlPlaceholder : baseUrl.TrimEnd('/');
            var packagesPath = GetConfiguredValue("packagesPath");

            return new PortalSettings
            {
                PublicPortalUrl = baseUrl,
                FeedUrl = baseUrl + "/nuget",
                PushApiKeyPlaceholder = GetConfiguredValue("apiKey") ?? DefaultApiKeyPlaceholder,
                PortalVersion = GetConfiguredValue("PortalVersion") ?? DefaultPortalVersion,
                PackageRepositoryPath = packagesPath ?? DefaultPackageRepositoryPath
            };
        }

        private static string GetConfiguredValue(string key)
        {
            var value = ConfigurationManager.AppSettings[key];
            if (!string.IsNullOrWhiteSpace(value))
            {
                return value;
            }

            value = Environment.GetEnvironmentVariable(key);
            if (!string.IsNullOrWhiteSpace(value))
            {
                return value;
            }

            var normalizedKey = key.Replace(':', '_');
            value = Environment.GetEnvironmentVariable(normalizedKey);
            if (!string.IsNullOrWhiteSpace(value))
            {
                return value;
            }

            return null;
        }
    }
}
