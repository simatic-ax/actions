const apaxNpmrc = process.env.RENOVATE_NPMRC;

const prFooter = `:space_invader: :sparkles: This merge request is proudly presented by [Renovate Bot](https://code.siemens.com/ax/devops/renovate-bot).`;
const autodiscoverFilter = "simatic-ax/*";
module.exports = {
  platform: "github",
  gitAuthor: "AX Bot <botax.industry@siemens.com>",
  prFooter: prFooter,
  requireConfig: "required",
  autodiscoverFilter: autodiscoverFilter,
  autodiscover: true,
  allowPostUpgradeCommandTemplating: true,
  allowedPostUpgradeCommands: [".+"],
  logFile: process.env.LOG_FILE,
  logFileLevel: process.env.LOG_FILE_LEVEL || "trace",
  cacheDir: process.env.CACHE_DIR,
  allowScripts: true,
  exposeAllEnv: true,
  ignoreScripts: true,
  npmrc: process.env.RENOVATE_NPMRC,
  labels: ["renovate"],
  hostRules: [
    {
      hostType: "npm",
      matchHost: "registry.simatic-ax.siemens.io",
      token: process.env.RENOVATE_APAX_TOKEN,
    },
  ],
  regexManagers: [
    {
      fileMatch: ["(^|\\/)(test.|test-windows.)?apax.ya?ml$"],
      matchStrings: [
        // We're using `String.raw` here so that the RegEx can be easily copied from/to other tools (e.g. https://regex101.com/)
        String.raw`"(?<depName>@ax\/.*?)"\s*:\s*"?(?<currentValue>[\d\.^\-\w]*)"?`,
      ],
      datasourceTemplate: "npm",
      // Unfortunately setting the registryUrl here does not work properly.
      // The registry can only be set via the `npmrc` property in the package rules.
      // Seems to be an NPM-specific weird behavior of Renovate, maybe related to
      // https://github.com/renovatebot/renovate/issues/4224
      // registryUrlTemplate: "https://axciteme.siemens.com/registry/apax/"
    },
    {
      fileMatch: ["(^|\\/)(test.|test-windows.)?apax.ya?ml$"],
      matchStrings: [
        // We're using `String.raw` here so that the RegEx can be easily copied from/to other tools (e.g. https://regex101.com/)
        String.raw`#\s*renovate:\s+datasource=(?<datasource>.*?)\s+depName=(?<depName>[\.\w]+)[\s-]+[\w]+_VERSION\s*=\s*"?(?<currentValue>[\d\.^\-\w]*)"?`,
      ],
    },
  ],
  packageRules: [
    {
      // Set endpoint and credentials for the Apax registry
      matchPaths: ["**/{test.,test-windows.,}apax.y{a,}ml"],
      npmrc: apaxNpmrc,
    },
    {
      // Ensure lock files are updated
      matchPaths: ["**/apax.y{a,}ml"],
      postUpgradeTasks: {
        // Switch to the directory of the apax.yml and update the lock file if it exists.
        commands: [
          `
          cd ./{{{packageFileDir}}} && 
          if test -f apax-lock.json; then 
            if apax install; then
              echo Successfully updated lock file.
            else
              echo Failed to update lock file.
            fi
          else
            echo No lock file to update.
          fi
        `,
        ],
        fileFilters: ["**/apax-lock.json"],
      },
    },
  ],
};
