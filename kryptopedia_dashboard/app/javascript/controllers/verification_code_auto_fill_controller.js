import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["form", "input"]

    connect() {
        const params = new URLSearchParams(window.location.search);
        const codeParam = params.get("code");
        console.log(codeParam);
        if (!codeParam) return;

        this.inputTarget.value = codeParam;
        this.formTarget.submit();
    }
}
