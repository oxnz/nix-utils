#!/bin/bash

# 全局提交用户名与邮箱
git config --global user.name "John Doe"
git config --global user.email johndoe@example.com

# 全局编辑器，提交时将COMMIT_EDITMSG编码转换成UTF-8可避免乱码
git config --global core.editor emacs
git config --global color.ui true
git config --global core.pager less
git config --global user.signingkey <gpg-key-id>
git config --global push.default simple
git config --global user.name "Yuchen Deng"
git config --global user.email loaden@gmail.com

# 中文编码支持
echo "export LESSCHARSET=utf-8" > $HOME/.profile
git config --global gui.encoding utf-8
git config --global i18n.commitencoding utf-8
git config --global i18n.logoutputencoding gbk

