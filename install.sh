#!/bin/zsh
echo "Checking if Rust is installed:"
if command -v rustc >/dev/null 
	then
		echo "Rust is installed!"
	else
    echo "Rust could not be found. Fetching Rust..."
		curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
		echo "Rust installed!"
fi

echo "Checking if CMake is installed:"
if command -v cmake >/dev/null 
	then
		echo "CMake is installed!"
	else 
		# Check if file is in applications folder
		# If not download, mount and copy over to applications
		# Delete downloaded file
		
		if [ -f "/Applications/CMake.app" ]; 
			then
				echo "CMake is installed!"
			else
				echo "CMake could not be found. Downloading CMake..."
				curl -o ./CMake.dmg https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1-macos-universal.dmg -L

				VOLUME=`hdiutil attach ./CMake.dmg | grep Volumes | awk '{print $3}'`
				cp -rf $VOLUME/*.app /Applications
				hdiutil detach $VOLUME
				
				echo "Removing downloaded CMake file..."
				rm ./CMake.dmg
				echo "Removed downloaded CMake file!"
		fi

		# Check if cmake is in path variable, otherwise add it.
    if grep -q /Applications/CMake.app/Contents/bin ~/.zshrc 
			then
				echo "CMake path variable found."
				exec source ~/.zshrc
			else
				echo "CMake path variable not found. Adding it..."
				echo "path+=('/Applications/CMake.app/Contents/bin')" >> ~/.zshrc
				echo "CMake path variable added."
				source ~/.zshrc #ISSUE
		fi
fi

echo "Requirements met. Installing Radicle CLI"

echo "Checking if Radicle is installed:"
if command -v rad >/dev/null 
	then
		echo "Radicle is already installed!"
	else 
	cargo install --force --locked --git https://seed.alt-clients.radicle.xyz/radicle-cli.git radicle-cli
	echo "Radicle is now installed!"
fi

