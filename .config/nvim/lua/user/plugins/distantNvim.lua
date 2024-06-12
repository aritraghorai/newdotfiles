return {
  {
    "chipsenkbeil/distant.nvim",
    branch = "v0.2",
    config = function() require("distant"):setup() end,
    cmd = {
      "DistantLaunch",
      "DistantOpen",
      "DistantConnect",
      "DistantInstall",
      "DistantMetadata",
      "DistantShell",
      "DistantShell",
      "DistantSystemInfo",
      "DistantClientVersion",
      "DistantSessionInfo",
      "DistantCopy",
    },
  },
}
