PLUGIN_ID := com.keyaruga.nerkh
PACKAGE_TYPE := Plasma/Applet

SRC_DIR := src
DIST_DIR := dist

METADATA := $(SRC_DIR)/metadata.json
VERSION := $(shell sed -n 's/.*"Version":[[:space:]]*"\([^"]*\)".*/\1/p' $(METADATA) | head -n 1)
PACKAGE := $(DIST_DIR)/nerkh-$(VERSION).zip

PLASMOID := plasmoidviewer
KPACKAGE := kpackagetool6

.PHONY: help run install upgrade uninstall reinstall package check version clean

help:
	@echo "Nerkh — KDE Plasma 6 Plasmoid"
	@echo
	@echo "Usage:"
	@echo "  make run        Run with plasmoidviewer"
	@echo "  make install    Install the Plasmoid"
	@echo "  make upgrade    Upgrade installed Plasmoid"
	@echo "  make reinstall  Remove and install again"
	@echo "  make uninstall  Remove the Plasmoid"
	@echo "  make package    Create KDE Store package"
	@echo "  make check      Check project structure"
	@echo "  make version    Show current version"
	@echo "  make clean      Remove generated files"
	@echo

run:
	$(PLASMOID) --applet "$(SRC_DIR)"

install:
	$(KPACKAGE) --type $(PACKAGE_TYPE) --install "$(SRC_DIR)"

upgrade:
	$(KPACKAGE) --type $(PACKAGE_TYPE) --upgrade "$(SRC_DIR)"

reinstall:
	-$(KPACKAGE) --type $(PACKAGE_TYPE) --remove $(PLUGIN_ID)
	$(KPACKAGE) --type $(PACKAGE_TYPE) --install "$(SRC_DIR)"

uninstall:
	$(KPACKAGE) --type $(PACKAGE_TYPE) --remove $(PLUGIN_ID)

package: check
	@mkdir -p "$(DIST_DIR)"
	@rm -f "$(PACKAGE)"
	@cd "$(SRC_DIR)" && zip -qr "../$(PACKAGE)" metadata.json contents
	@echo "Package created: $(PACKAGE)"

check:
	@test -f "$(METADATA)" || \
		(echo "ERROR: $(METADATA) not found"; exit 1)
	@test -d "$(SRC_DIR)/contents" || \
		(echo "ERROR: $(SRC_DIR)/contents/ not found"; exit 1)
	@test -d "$(SRC_DIR)/contents/config" || \
		(echo "ERROR: $(SRC_DIR)/contents/config/ not found"; exit 1)
	@test -d "$(SRC_DIR)/contents/icons" || \
		(echo "ERROR: $(SRC_DIR)/contents/icons/ not found"; exit 1)
	@test -d "$(SRC_DIR)/contents/ui" || \
		(echo "ERROR: $(SRC_DIR)/contents/ui/ not found"; exit 1)
	@test -f "$(SRC_DIR)/contents/ui/main.qml" || \
		(echo "ERROR: $(SRC_DIR)/contents/ui/main.qml not found"; exit 1)
	@test -f "$(SRC_DIR)/contents/config/main.xml" || \
		(echo "ERROR: $(SRC_DIR)/contents/config/main.xml not found"; exit 1)
	@echo "Project structure: OK"

version:
	@echo "$(VERSION)"

clean:
	@rm -rf "$(DIST_DIR)"
	@echo "Cleaned generated files."
