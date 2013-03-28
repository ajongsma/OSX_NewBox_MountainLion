﻿(function () {
    "use strict";

    var appData = Windows.Storage.ApplicationData.current.roamingSettings;
    var appView = Windows.UI.ViewManagement.ApplicationView;
    var appViewState = Windows.UI.ViewManagement.ApplicationViewState;
    var nav = WinJS.Navigation;
    var ui = WinJS.UI;

    ui.Pages.define("/pages/sickbeard/sickbeard.html", {
        // Navigates to the groupHeaderPage. Called from the groupHeaders,
        // keyboard shortcut and iteminvoked.
        navigateToGroup: function (key) {
            nav.navigate("/pages/sickbeard/sbDetails/sbDetails.html", { groupKey: key });
        },

        // This function is called whenever a user navigates to this page. It
        // populates the page elements with the app's data.
        ready: function (element, options) {
            var listView = element.querySelector(".groupeditemslist").winControl;
            listView.groupHeaderTemplate = element.querySelector(".headertemplate");
            listView.itemTemplate = element.querySelector(".itemtemplate");
            listView.oniteminvoked = this._itemInvoked.bind(this);

            // Set up a keyboard shortcut (ctrl + alt + g) to navigate to the
            // current group when not in snapped mode.
            listView.addEventListener("keydown", function (e) {
                if (appView.value !== appViewState.snapped && e.ctrlKey && e.keyCode === WinJS.Utilities.Key.g && e.altKey) {
                    var data = listView.itemDataSource.list.getAt(listView.currentItem.index);
                    this.navigateToGroup(data.group.key);
                    e.preventDefault();
                    e.stopImmediatePropagation();
                }
            }.bind(this), true);

            this._initializeLayout(listView, appView.value);
            listView.element.focus();

            // manage all shows button
            //element.querySelector(".titlearea button.manage-all-shows").onclick = function () {
                //nav.navigate("/pages/sickbeard/manageShows/manageShows.html");
            //}

            /* ===============================================
                APP BAR FUNCTIONS
            =============================================== */

            // Launch Sickbeard
            document.getElementById("launchSickbeard").onclick = function () {
                var sbURL = "http://" + appData.values['sbIP'] + ":" + appData.values['sbPort'];
                location.href = sbURL;
            }

            // Recently Downloaded
            document.getElementById("sbHistory").onclick = function () {
                nav.navigate("/pages/sickbeard/sbHistory/sbHistory.html");
            }

            // All Shows
            document.getElementById("sbAllShows").onclick = function () {
                nav.navigate("/pages/sickbeard/sbAllShows/sbAllShows.html");
            }

            // Season Start Dates 
            document.getElementById("sbStartDates").onclick = function () {
                nav.navigate("/pages/sickbeard/sbStartDates/sbStartDates.html");
            }

            // Add Show
            document.getElementById("sbAddShow").onclick = function () {
                //
            }
        },

        // This function updates the page layout in response to viewState changes.
        updateLayout: function (element, viewState, lastViewState) {
            /// <param name="element" domElement="true" />

            var listView = element.querySelector(".groupeditemslist").winControl;
            if (lastViewState !== viewState) {
                if (lastViewState === appViewState.snapped || viewState === appViewState.snapped) {
                    var handler = function (e) {
                        listView.removeEventListener("contentanimating", handler, false);
                        e.preventDefault();
                    }
                    listView.addEventListener("contentanimating", handler, false);
                    this._initializeLayout(listView, viewState);
                }
            }
        },

        // This function updates the ListView with new layouts
        _initializeLayout: function (listView, viewState) {
            /// <param name="listView" value="WinJS.UI.ListView.prototype" />

            if (viewState === appViewState.snapped) {
                listView.itemDataSource = SBData.groups.dataSource;
                listView.groupDataSource = null;
                listView.layout = new ui.ListLayout();
            } else {
                listView.itemDataSource = SBData.items.dataSource;
                listView.groupDataSource = SBData.groups.dataSource;
                listView.layout = new ui.GridLayout({ groupHeaderPosition: "top" });
            }
        },

        _itemInvoked: function (args) {
            if (appView.value === appViewState.snapped) {
                // If the page is snapped, the user invoked a group.
                var group = SBData.groups.getAt(args.detail.itemIndex);
                this.navigateToGroup(group.key);
            } else {
                // If the page is not snapped, the user invoked an item.
                var item = SBData.items.getAt(args.detail.itemIndex);
                nav.navigate("/pages/sickbeard/sbDetails/sbDetails.html", { item: SBData.getItemReference(item), type: "SBData" });
            }
        }
    });



})();