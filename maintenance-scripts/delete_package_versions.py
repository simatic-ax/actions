import os
import requests

def delete_package_versions(org_name, package_name):
    token = os.getenv("PACKAGE_DELETE_TOKEN")
    headers = {
        "Authorization": f"Bearer {token}",
        "Accept": "application/vnd.github+json"
    }

    package_versions_url = f"https://api.github.com/orgs/{org_name}/packages/npm/{package_name}/versions"
    response = requests.get(package_versions_url, headers=headers)

    if response.status_code != 200:
        print(f"Failed to fetch package versions: {response.status_code} - {response.text}")
        return

    versions = response.json()

    for version in versions:
        version_id = version.get("id")
        version_name = version.get("metadata", {}).get("container", {}).get("tags", [])
        print(f"Deleting version {version_name} (ID: {version_id})")

        delete_url = f"{package_versions_url}/{version_id}"
        delete_response = requests.delete(delete_url, headers=headers)

        if delete_response.status_code == 204:
            print(f"Successfully deleted version {version_name} (ID: {version_id})")
        else:
            print(f"Failed to delete version {version_name} (ID: {version_id}) - {delete_response.status_code} - {delete_response.text}")

if __name__ == "__main__":
    delete_package_versions("simatic-ax", "template-actions-test")
    delete_package_versions("simatic-ax", "actions-test")