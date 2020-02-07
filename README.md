## Requirements

* Ruby >= 0
* OAuth2
* Quickbook refresh token, can generate via Quickbook playground https://developer.intuit.com/app/developer/playground 


## Installation

* Execute below command 
    gem install quick_book_gateway

## How to use

1.  Add line to your ruby program

    require 'quick_book_gateway'


2. Configure Quickbook by adding below line to your ruby program

        Gateway::Quickbook.connect(
            :client_id      =>   QuickBook App Client ID,
            :client_secret  =>   QuickBook App Client Secret,
            :refresh_token  =>   Can generate from playground https://developer.intuit.com/app/developer/playground, validate for 100 days
            :company_id     =>   QuickBook Company ID,
            :environment    =>   ENVIRONMENT::SANDBOX or ENVIRONMENT::PRODUCTION
        )

3.  Create classes with names provided on Quickbook website 

    https://developer.intuit.com/v2/apiexplorer?apiname=V3QBO

    For ex. Account, Customer, Vendor, Invoice, Item, etc


4. Inherit all classes with Service::Record Class, class should look like below

    class Customer < Service::Record
    end

    class Vendor < Service::Record
    end

    class Item < Service::Record
    end

5.  You are ready to create, fetch or modify any data on Quickbook.
    
    For ex.

    customer = Customer.find(DisplayName: "Kunal")
    customer.CompanyName = "Kunal Lalge"
    customer.save!

6.  For attributes reference read Documentation reference for each class on Quickbook link provided above.

    For ex. https://developer.intuit.com/docs/api/accounting/customer
  
7.  One can also use callbacks, below are list of callbacks:

        before_save         -   Executes every time before object save
        after_save          -   Executes every time after object save
        before_create       -   Executes only before new object save
        after_create        -   Executes only after new object save
        before_update       -   Executes only before existing object save
        after_update        -   Executes only after existing object save
        before_destroy      -   Executes every time before destroy an object
        after_destroy       -   Executes every time after destroy an object

    Example 
    
        class Customer < Service::Record
            def after_create
                puts "New customer is created on QB"
            end
        end


## UPDATES

0.0.4   - find_all will fetch all records using pagination

0.0.5   - Quickbook OAuth 2.0 security upgradation implemented


THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
AUTHOR BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN 
ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION 
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.