.PHONY: build
build: asyncrule.py
	python setup.py -v bdist_wheel

asyncrule.py: asyncrule.hy
	hy2py -o $@ $<
