# Function to set up Tailwind CSS
setup_tailwind() {
    local project_dir="${1:-.}" # Use the provided directory or default to the current directory
    local styles_file="${2:-styles.css}" # Path to the styles.css file, defaulting to src/styles.css

    # Resolve the absolute path of the project directory
    local resolved_project_dir
    if [ "$project_dir" = "." ]; then
        resolved_project_dir=$(pwd)
    else
        resolved_project_dir=$(realpath "$project_dir")
    fi

    # Navigate to the project directory
    cd "$resolved_project_dir" || return

    # Check if package.json exists
    if [ -f "package.json" ]; then
        # Install required dependencies
        yarn add -D tailwindcss postcss autoprefixer

        # Generate Tailwind CSS configuration files
        npx tailwindcss init -p

        # Create the specified CSS file if it doesn't exist
        mkdir -p "$(dirname "$styles_file")"
        touch "$styles_file"

        # Add basic styles to the CSS file
        echo "@import 'tailwindcss/base';" >> "$styles_file"
        echo "@import 'tailwindcss/components';" >> "$styles_file"
        echo "@import 'tailwindcss/utilities';" >> "$styles_file"

        # Inform the user
        echo "Tailwind CSS has been set up in $resolved_project_dir"


    if [ -f "$project_dir/composer.json" ]; then
        cat > tailwind.config.js <<EOL
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./resources/**/*.blade.php",
    "./resources/**/*.js",
    "./resources/**/*.vue",
  ],
  theme: {
    extend: {
        container: {
            center: true,
        },
    },
  },
  plugins: [],
}
EOL
    else
cat > tailwind.config.js <<EOL
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
        container: {
            center: true,
        },
    },
  },
  plugins: [],
}
EOL
    fi
        # Inform the user with green text
        echo -e "\e[32mDONE\e[0m - Tailwind CSS has been set up in $resolved_project_dir"
    else
        echo "Error: No package.json found in $resolved_project_dir"
    fi
}

# Alias for the function
alias tailwind="setup_tailwind"
