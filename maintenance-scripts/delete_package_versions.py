import os
from github import Github

def delete_package_versions(org_name, package_name):
    token = os.getenv("PACKAGE_DELETE_TOKEN")
    g = Github(token)
    org = g.get_organization(org_name)
    package = org.get_package("container", package_name)
    
    for version in package.get_versions():
        print(f"Deleting version: {version}")
        version.delete()

if __name__ == "__main__":
    delete_package_versions("simatic-ax", "template-actions-test")
    delete_package_versions("simatic-ax", "actions-test")