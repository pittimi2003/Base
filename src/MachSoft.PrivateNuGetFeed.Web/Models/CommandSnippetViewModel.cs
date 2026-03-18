namespace MachSoft.PrivateNuGetFeed.Web.Models
{
    public class CommandSnippetViewModel
    {
        public CommandSnippetViewModel(string title, string command)
        {
            Title = title;
            Command = command;
        }

        public string Title { get; }

        public string Command { get; }
    }
}
