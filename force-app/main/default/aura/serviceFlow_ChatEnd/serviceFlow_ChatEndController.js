({
    onChatEnded: function(component, event, helper) {
        let workspaceAPI = component.find( "workspace");
        workspaceAPI.getFocusedTabInfo().then( function( response ) {
            let focusedTabId = response.tabId;
            let recordId = response.recordId;
            component.set("v.isModalOpen",true);
            window.setTimeout(
                $A.getCallback(function() {
                    workspaceAPI.closeTab( { tabId: focusedTabId } );
                }), 300000
            );
            
        })
        .catch(function( error ) {
            console.log( 'Error is' + JSON.stringify( error ) );
        });
    },
    closeModel: function(component, event, helper) {        
        let workspaceAPI = component.find( "workspace");
        workspaceAPI.getFocusedTabInfo().then( function( response ) {
            let focusedTabId = response.tabId;
            let recordId = response.recordId;
            workspaceAPI.refreshTab({
                tabId: focusedTabId,
                includeAllSubtabs: true
            });
            component.set("v.isModalOpen", false);
        })
        .catch(function( error ) {
            console.log( 'Error is' + JSON.stringify( error ) );
            component.set("v.isModalOpen", false);
        });
    },
    handleChat11 : function(component, event, helper) {
        event.preventDefault();
        const fields = event.getParam('fields');
        component.find("chatForm").submit();        
        let workspaceAPI = component.find( "workspace");
        workspaceAPI.getFocusedTabInfo().then( function( response ) {
            let focusedTabId = response.tabId;
            let recordId = response.recordId;  
            workspaceAPI.refreshTab({
                tabId: focusedTabId,
                includeAllSubtabs: true
            });
            component.set("v.isModalOpen", false);
        })
        .catch(function( error ) {
            console.log( 'Error is' + JSON.stringify( error ) );
            component.set("v.isModalOpen", false);
        });
    },
    handleChat: function(component, event, helper) {
        event.preventDefault();
        const fields = event.getParam('fields');
        component.find("chatForm").submit();
        
        let workspaceAPI = component.find( "workspace");
        workspaceAPI.getFocusedTabInfo().then( function( response ) {
            let focusedTabId = response.tabId;
            let recordId = response.recordId;
            
            window.setTimeout(
                $A.getCallback(function() {
                    workspaceAPI.closeTab( { tabId: focusedTabId } );
                    component.set("v.isModalOpen",false);
                }), 500
            );
            
        })
        .catch(function( error ) {
            console.log( 'Error is' + JSON.stringify( error ) );
        });
    },
})