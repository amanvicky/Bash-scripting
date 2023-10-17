# Updated on 2023-10-17
#!/bin/bash
# User Onboarding Script
read -p "Enter username: " USERNAME
if id "$USERNAME" &>/dev/null; then
  echo "User $USERNAME already exists."
else
  echo "Adding user $USERNAME..."
fi

