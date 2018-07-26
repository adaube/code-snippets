# install zsh, git, a couple plugins, and fonts required for the agnoster theme
apt install -y zsh git zsh-doc zsh-syntax-highlighting fonts-powerline
# IMPORTANT: for agnoster theme, or any powerline style theme, change system fonts for mono to the Powerline medium one
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
# set shell to oh-my-zsh
chsh -s /bin/zsh

# optional: pure
cd /opt
git clone https://github.com/sindresorhus/pure.git
ln -s "$PWD/pure.zsh" /usr/local/share/zsh/site-functions/prompt_pure_setup
ln -s "$PWD/async.zsh" /usr/local/share/zsh/site-functions/async
echo "# init prompt for pure" >> ${ZDOTDIR:-$HOME}/.zshrc
echo "autoload -U promptinit; promptinit" >> ${ZDOTDIR:-$HOME}/.zshrc
echo "prompt pure" >> ${ZDOTDIR:-$HOME}/.zshrc
echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zs
cd ~/.oh-my-zsh/plugins
git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions

# fix the path if zsh or bash becomes broken :)
export PATH=/bin:/usr/bin:/usr/local/bin

# clone antigen-hs
git clone https://github.com/Tarrasch/antigen-hs.git ~/.zsh/antigen-hs/

# edit then recompile antigen-hs
nano ~/.zsh/MyAntigen.hs
echo 'source ~/.zsh/antigen-hs/init.zsh' | tee -a ~/.zshrc | env zsh
antigen-hs-setup
