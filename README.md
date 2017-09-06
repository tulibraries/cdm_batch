# CdmBatch

## Installation on Windows

Before we can start using cdm_batch on Windows machine, we need to make sure Ruby and Git are installed.

### Installing Ruby
Download Ruby 2.4.1-2 from [RubyInstaller](http://rubyinstaller.org). Make sure to select the one-click installer, and not the archive. 

While following the installer instructions, when it asks about the installation path, use the default installation path, but make sure to tick the `Add Ruby executables to your PATH` and `Associate .rb and .rbw files with this Ruby Installation` checkboxes.

### Git

Download [Git for Windows](https://git-scm.com/download/win) and run the installer. 
* On the `Select Components` screen of the instllation, ensure that the `Windows Explorer Integration`, `Git Bash Here`, and `Git GUI Here` boxes are ticked.
* In the `Adjusting you PATH environment` screen, select the `Use Git from the Windows Command Prompt` option is ticked.

With those two steps complete, we can now install `cdm_batch`.

### Checkout the tul_cdm repository

In the start menu, search for "ruby" abnd the select `Start Command Prompt with Ruby`. This will start a command line window where we are going to run some commands to install .

Now clone the cdm_batch repository with the command 

`git clone https://github.com/tulibraries/cdm_batch`

Now change directories into cdm_batch and setup the application.
```bash
cd cdm_batch
gem install bundler
bundle install
```

Now we are going to set up the credentials for uploading the files.

In the cdm_batch directory we have just created, copy the `cdm_creds.example` file to a new file just called `cdm_creds`. Then open the new file you just created in your favorite text editor. It should look like:

```yaml
---

username: SOMEUSERNAME
password: SOMEPASSWORD
```

Update `SOMEUSERNAME` and `SOMEPASSWORD` to reflect the username you use to log into ContentDM.

And that's it.

## Uploading batches of collections

cdm_batch expects that the files to be uploaded are in the same directory as the tab delimited file containing the metadata about those files.

In the start menu, search for "ruby" abnd the select `Start Command Prompt with Ruby`. This will start a command line window where we are going to run some commands to upload the file.

Ensure you are in the directory where you installed `cdm_batch`. Then run something like

`rake upload_etd[D:/PATH/TO/etd_tab.txt] <--- EXAMPLE - DO NOT COPY`

where `D:/PATH/TO/etd_tab.txt` is the actual path to your tab delimted metdata file. One thing to note here - Ruby expects the path to your file to be written using forward slashes, not the back slashes. For example, if the path windows is displaying is: 
`C:\Users\chad\Desktop\upload_these\etd_tab.txt` 

then your rake command would have to flip the slashes, so it would be: 

`rake upload_etd[C:/Users/chad/Desktop/upload_these/etd_tab.txt]`

### Testing
If you want to test with the Dissertations Test colelctions, use the command `rake upload_etd_test[D:/PATH/TO/etd_tab.txt]` instead.

### Logging

Running the upload-batch process will create several log files in the same directory.
* `batch_upload.log` ## listing the successfully uploaded files. 
* `batch_upload-failed.log` ## listing the files that could not be uploaded
* `could_not_be_uploaded.tsv` ## outputs the metadata frm the original tab delimited file for failed items so they can be uploaded with the project client. 


