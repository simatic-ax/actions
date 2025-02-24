import os
import shutil
import subprocess
from github import Github
from pathlib import Path

# Konfiguration
GITHUB_TOKEN = "your_github_token_here"
WORKFLOW_SOURCE_PATH = "./workflow_templates"  # Pfad zu den Workflow-Dateien
EXCLUDED_REPOS = [
    "actions",
    "template-ax2tia",
    "renovate-config",
    "template-app", # manuell anpassen
    "learning-path",
    "apax-cheat-sheet",
    "tipps-and-tricks",
    "template-library", # manuell anpassen
    "snippetscollection"
    ".github",
    ".discussions"
    # Weitere Repos hier hinzufügen
]
BASE_PATH = "./repos"  # Lokaler Pfad, wo die Repos geklont werden sollen
ORGANIZATION = "simatic-ax"

# Pull Request Konfiguration
PR_TITLE = "ops(ci-infrastructure): Adds a development and a release workflow for maintenance"
PR_BODY = """This commit will add two new workflows to the repository. The development workflow may be used during the development phase of the project. The release workflow may be used to publish the final artifact."""

class GitHubRepoManager:
    def __init__(self):
        self.github = Github(GITHUB_TOKEN)
        self.org_name = ORGANIZATION
        self.base_path = Path(BASE_PATH)
        self.base_path.mkdir(exist_ok=True)

    def clone_and_process_repos(self):
        org = self.github.get_organization(self.org_name)
        repos = org.get_repos(type='public')

        print(f"Starting to process repositories for {self.org_name}")
        print(f"Excluding the following repositories: {', '.join(EXCLUDED_REPOS)}")
        print(f"Using workflow files from: {WORKFLOW_SOURCE_PATH}")

        for repo in repos:
            if repo.name in EXCLUDED_REPOS:
                print(f"\nSkipping excluded repository: {repo.name}")
                continue

            print(f"\nProcessing repository: {repo.name}")
            self._process_single_repo(repo)

    def _process_single_repo(self, repo):
        repo_path = self.base_path / repo.name

        # Clone repository if not exists
        if not repo_path.exists():
            print(f"Cloning {repo.name}...")
            subprocess.run(['git', 'clone', repo.clone_url, str(repo_path)], check=True)

        # Change to repo directory
        os.chdir(str(repo_path))

        try:
            # Fetch and create new branch
            subprocess.run(['git', 'fetch', 'origin'], check=True)
            subprocess.run(['git', 'checkout', 'main'], check=True)
            subprocess.run(['git', 'pull'], check=True)

            # Create and checkout new branch
            branch_name = 'incorporate-github-actions'
            subprocess.run(['git', 'checkout', '-B', branch_name], check=True)

            # Handle .github directory
            github_dir = repo_path / '.github'
            workflows_dir = github_dir / 'workflows'

            if github_dir.exists():
                print(f"Removing existing .github directory in {repo.name}")
                shutil.rmtree(str(github_dir))

            print(f"Creating new .github/workflows directory in {repo.name}")
            github_dir.mkdir(exist_ok=True)
            workflows_dir.mkdir(exist_ok=True)

            # Copy workflow files
            workflow_source = Path(WORKFLOW_SOURCE_PATH)
            if not workflow_source.exists():
                raise Exception(f"Workflow source path {WORKFLOW_SOURCE_PATH} does not exist!")

            files_copied = 0
            for workflow_file in workflow_source.glob('*'):
                if workflow_file.is_file():
                    shutil.copy2(str(workflow_file), str(workflows_dir))
                    files_copied += 1

            print(f"Copied {files_copied} workflow files to {repo.name}")

            # Add changes and commit
            subprocess.run(['git', 'add', '.'], check=True)

            # Check if there are changes to commit
            status = subprocess.run(['git', 'status', '--porcelain'], 
                                 capture_output=True, text=True).stdout

            if status:
                print(f"Committing changes in {repo.name}")
                subprocess.run(['git', 'commit', '-m', 
                             'Adds a release and development workflow'], check=True)
                print(f"Pushing changes to {repo.name}")
                subprocess.run(['git', 'push', '-f', 'origin', branch_name], check=True)

                # Create Pull Request
                pr = repo.create_pull(
                    title=PR_TITLE,
                    body=PR_BODY,
                    head=branch_name,
                    base='main'
                )
                print(f"Created Pull Request #{pr.number} for {repo.name}")
            else:
                print(f"No changes to commit for {repo.name}")

        except Exception as e:
            print(f"Error processing {repo.name}: {str(e)}")

        finally:
            # Change back to original directory
            os.chdir(str(self.base_path.parent))

def main():
    try:
        if not GITHUB_TOKEN or GITHUB_TOKEN == "your_github_token_here":
            raise ValueError("Please set your GitHub token in the script!")

        if not os.path.exists(WORKFLOW_SOURCE_PATH):
            raise ValueError(f"Workflow source path {WORKFLOW_SOURCE_PATH} does not exist!")

        manager = GitHubRepoManager()
        manager.clone_and_process_repos()

    except Exception as e:
        print(f"Error: {str(e)}")
        return 1

    return 0

if __name__ == "__main__":
    exit(main())