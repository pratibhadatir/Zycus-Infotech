import { LightningElement, track, api, wire } from 'lwc';
import getCaseNotes from '@salesforce/apex/VLSF_AddNotes.getCaseNotes';
import createNotes from '@salesforce/apex/VLSF_AddNotes.createNotes';
import deletenote from '@salesforce/apex/VLSF_AddNotes.deletenote';
import updateNote from '@salesforce/apex/VLSF_AddNotes.updateNote';
// import getTotalNotesCount from '@salesforce/apex/VLSF_AddNotes.getTotalNotesCount';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';
const PAGE_SIZE = 6;
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class VlsfAddNote extends NavigationMixin(LightningElement) {

    @track isModalOpen = false;
    @track subject = '';
    @track description = '';
    @api objectType;
    loaded = true;
    openModal() {
        this.isModalOpen = true;
    }
    closeModal() {
        this.isModalOpen = false;
    }
    handleSubjectChange(event) {
        this.subject = event.target.value;
        // console.log('subject', this.subject);
    }
    handleDescriptionChange(event) {
        this.description = event.target.value;
        // console.log('description', this.description);
    }

    connectedCallback() {
        console.log('objectType', this.objectType);
        console.log('record Id', this.recordId);
    }

    rerenderedCallback() {
        this.refreshData();
        console.log('record Id', this.recordId);
        setTimeout(function () {
            this.refreshData();
        }, 3000);
    }

    createNoteInContentVersion() {
        createNotes({ subject: this.subject, description: this.description, caseId: this.recordId, objectType: this.objectType })
            .then(result => {
                // handle successful response
                console.log('result', result);
                if (result.includes('Error:')) {
                    // Display error toast
                    this.showToast('Error', result, 'error');
                } else {
                    // Display success toast
                    this.showToast('Success', result, 'success');
                }
                this.loaded = true;
            })
            .catch(error => {
                // handle error
                console.error(error);
                console.error('Error:', error);
                this.loaded = true;
            });
        this.refreshData();
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }

    saveContent() {
        this.loaded = false;
        this.createNoteInContentVersion();
        this.subject = '';
        this.description = '';
        this.isModalOpen = false;
        this.refreshData();
    }

    // setTimeout(function() {
    //     console.log('This message will be logged after 2 seconds');
    // }, 2000);

    @api recordId;
    @api pageNumber = 1;
    @track caseNotes = [];
    totalNotesCount = 0;


    @track totalNotes;
    @track showNotes = false;
    wiredResult;

    @wire(getCaseNotes, { caseId: '$recordId', objectType: '$objectType' })
    wiredCaseNotes(result) {

        this.wiredResult = result;
        let { data, error } = result;
        try {
            if (data != null || JSON.stringify(data) != undefined) {
                this.showNotes = true;
                this.totalNotes = data;
                console.log('result data', this.totalNotes.length());
            } else if (error) {
                this.showNotes = false;
                console.error('Error fetching case notes:', result.error);
            }
        } catch (error) {

        }

    }

    refreshData() {
        return refreshApex(this.wiredResult);
    }

    // refreshData() {
    //     refreshApex(this.wiredResult).then(() => {
    //         console.log('Data refreshed successfully');
    //     }).catch(error => {
    //         console.error('Error refreshing data:', error);
    //     });
    // }


    updateContentHandler(event) {
        this.caseNotes = [...event.detail.records]
        console.log(event.detail.records);
        this.refreshData();
    }

    handlePageChange(event) {
        this.pageNumber = event.detail.page;
    }

    navigateToRecordEditPage(event) {

        let noteId = event.target.dataset.noteid;
        let title = event.target.dataset.title;
        let description = event.target.dataset.description;
        // console.log('noteId::', noteId);
        console.log('title::', title);
        // console.log('descrption::', description);
        this.updatetitle = title;
        this.updatedescription = description;
        this.updateNoteId = noteId;
        this.isUpdateModal = true;
        // Opens the Account record modal
        // to view a particular record.

        // this[NavigationMixin.Navigate]({
        //     type: "standard__recordPage",
        //     attributes: {
        //         recordId: noteId,
        //         objectApiName: "VLSF_Custom_Note__c", // objectApiName is optional
        //         actionName: "edit",
        //     },
        // });
        // this.refreshData();
        // setTimeout(function () {
        //     this.refreshData();
        // }, 3000);
    }

    deleteSelectednote(event) {
        this.loaded = false;
        let noteId = event.target.dataset.noteid;
        console.log('noteId::', noteId);
        deletenote({ recordId: noteId })
            .then(result => {
                // handle successful response
                console.log('result', result);
                if (result.includes('Error:')) {
                    // Display error toast
                    this.showToast('Error', result, 'error');
                } else {
                    // Display success toast
                    this.showToast('Success', result, 'success');
                }
                this.loaded = true;
            })
            .catch(error => {
                // handle error
                console.error(error);
                console.error('Error:', error);
                this.loaded = true;
            });
        this.refreshData();
    }

    updatedescription;
    updatetitle;
    updateNoteId;
    isUpdateModal = false;

    handleUpdateSubjectChange(event) {
        this.updatetitle = event.target.value;
        // console.log('subject', this.subject);
    }
    handleUpdateDescriptionChange(event) {
        this.updatedescription = event.target.value;
        // console.log('description', this.description);
    }

    updateContent() {
        this.loaded = false;
        this.updateSelectedNote();
        this.updatetitle = '';
        this.updatedescription = '';
        this.isModalOpen = false;
        this.updateNoteId = '';
        this.refreshData();
    }


    updateSelectedNote() {
        this.loaded = false;
        // console.log('updateNoteId::', updateNoteId);
        console.log('updatetitle::', this.updatetitle);
        updateNote({ recordId: this.updateNoteId, title: this.updatetitle, description: this.updatedescription })
            .then(result => {
                // handle successful response
                console.log('result', result);
                if (result.includes('Error:')) {
                    // Display error toast
                    this.showToast('Error', result, 'error');
                } else {
                    // Display success toast
                    this.showToast('Success', result, 'success');
                }
                this.loaded = true;
                this.isUpdateModal = false;
            })
            .catch(error => {
                // handle error
                console.error(error);
                console.error('Error:', error);
                this.isUpdateModal = false;
                this.loaded = true;
            });
        this.refreshData();
    }

    closeupdateModal() {
        this.isUpdateModal = false;
    }

}