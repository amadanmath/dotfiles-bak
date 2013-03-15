#!/bin/sh

set -ex

cd ~/.homesick/repos/amadanmath/dotfiles
git stash
homesick pull amadanmath/dotfiles
git stash pop
cd -
