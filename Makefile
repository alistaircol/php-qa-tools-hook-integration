.ONESHELL:
.PHONY: init
init:
    git config core.hookspath "$(pwd)/.githooks"

qa_docker = docker run \
    --init \
    --tty \
    --rm \
    --user=$$(id -u) \
    --volume="$$(pwd):/project" \
    --workdir "/project" \
    jakzal/phpqa:php7.3

files_in_git_diff = git --no-pager diff --name-only --staged
php_files_in_git_diff = ${files_in_git_diff} --diff-filter=AMRC -- '*.php'

phplint:
	@${qa_docker} phplint $(args)

phpcs:
	@${qa_docker} phpcs -s $(args)

phpdiff:
	@${php_files_in_git_diff}

# would be awesome do to make phpdiff --one-line
# but this is tricky to do, but this works too.
phpdiff-one-line:
	@${php_files_in_git_diff} | paste --serial --delimiters=' '
