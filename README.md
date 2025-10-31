# neovim.config
My Personal Neovim Configuration

A clean, modular Neovim configuration optimized for development productivity.

## 📁 Structure

    .neovim.config/ 
    ├── init.vim # Main configuration entry point 
    ├── autoload/ # Autoload scripts 
    ├── colors/ # Custom color schemes 
    │   └── molokai256.vim # Molokai 256-color theme 
    ├── configs/ # Modular configuration files 
    │   ├── 1.plugins.vim # Plugin definitions 
    │   ├── 2.plugins-settings.vim # Plugin-specific settings 
    │   └── 3.settings.vim # General Neovim settings 
    ├── ftplugin/ # Filetype-specific configurations 
    │   └── java.vim # Java language settings 
    └── .gitignore # Git ignore patterns

## 🚀 Installation

### Prerequisites

- Neovim 0.5+ installed
- Git for cloning the repository

### Quick Setup

1. **Clone this configuration:**
   ```sh
   git clone https://github.com/wesilios/neovim.config ~/.config/nvim
   ```

2. **Install vim-plug (plugin manager):**
   ```sh
   curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
   ```

3. **Install plugins:**
   - Open Neovim: `nvim`
   - Run: `:PlugInstall`
   - Restart Neovim

### Manual Installation

If you prefer to set up manually:

1. Back up your existing configuration:
   ```sh
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. Create the configuration directory:
   ```sh
   mkdir -p ~/.config/nvim
   ```

3. Copy files to the configuration directory
4. Follow steps 2-3 from Quick Setup above

## ⚡ Features

- **Modular Configuration**: Organized into separate files for easy maintenance
- **Plugin Management**: Uses vim-plug for efficient plugin handling
- **Custom Color Scheme**: Includes Molokai 256-color theme
- **Language Support**: Java-specific configurations included
- **Clean Structure**: Well-organized directory layout

## 🔧 Customization

### Adding New Plugins

Edit `configs/1.plugins.vim` and add your plugin using vim-plug syntax:
```vim
Plug 'author/plugin-name'
```

### Modifying Settings

- General settings: Edit configs/3.settings.vim 
- Plugin settings: Edit configs/2.plugins-settings.vim 
- Language-specific: Add files to ftplugin/ directory

### Adding Color Schemes
Place .vim color scheme files in the colors/ directory.

### 📋 Plugin List
The configuration includes carefully selected plugins for enhanced productivity. Check configs/1.plugins.vim for the complete list.

## 🤝 Contributing
1. Fork the repository 
2. Create your feature branch: git checkout -b feature/amazing-feature 
3. Commit your changes: git commit -m 'Add some amazing feature' 
4. Push to the branch: git push origin feature/amazing-feature 
5. Open a Pull Request

## 📝 License
This project is licensed under the MIT License - see the LICENSE file for details.

## 🙋‍♂️ Support
If you encounter any issues or have questions:
- Open an issue on GitHub
- Check the Neovim documentation 
- Visit vim-plug documentation

