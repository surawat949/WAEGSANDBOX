({
    onChatEnded: function(component, event, helper) {
        let workspaceAPI = component.find( "workspace");
        workspaceAPI.getFocusedTabInfo().then( function( response ) {
            let focusedTabId = response.tabId;
            let recordId = response.recordId;
            component.set("v.isModalOpen",true);
            component.set("v.currentUserId",$A.get("$SObjectType.CurrentUser.Id"));
            helper.doInit(component, event, helper);
            //component.set("v.selectedSubSubject", component.find("SubSubject").get("v.value"));
            window.setTimeout(
                $A.getCallback(function() {
                    workspaceAPI.closeTab( { tabId: focusedTabId } );
                }), 600000
            );
        })
        .catch(function( error ) {
            console.log( 'Error is' + JSON.stringify( error ) );
        });
    },
    closeModel: function(component, event, helper) {        
       helper.closeModel(component, event, helper);
    },
    createCase: function (component, event, helper) {
        helper.validateInputFields(component, event, helper, "Case");
    },
    resetErrors: function (component, event, helper) {
        helper.resetErrors(component, event, helper);
    },
    UploadFinished : function(component, event, helper) {  
        let uploadedFiles = event.getParam("files");  
        component.set("v.selectedFileName",uploadedFiles[0].name);
        component.set("v.selectedDocumentId",uploadedFiles[0].documentId);
    }
})