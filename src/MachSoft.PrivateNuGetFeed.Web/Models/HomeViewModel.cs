using System.Collections.Generic;

namespace MachSoft.PrivateNuGetFeed.Web.Models
{
    public class HomeViewModel
    {
        public string PortalBaseUrl { get; set; }

        public string FeedUrl { get; set; }

        public string PushApiKeyPlaceholder { get; set; }

        public string PortalVersion { get; set; }

        public int CurrentYear { get; set; }

        public string PackageRepositoryPath { get; set; }

        public IReadOnlyCollection<CommandSnippetViewModel> Commands { get; set; }

        public IReadOnlyCollection<PackageHighlightViewModel> FeaturedPackages { get; set; }

        public IReadOnlyCollection<string> QuickGuide { get; set; }

        public IReadOnlyCollection<string> Notes { get; set; }
    }
}
