# 🚀 Clarify Capital Lender Match App

A full-stack Rails application to manage clients, lenders, and loans. 

---

## 🎯 Features

1. **Clients**
    - Create new clients via clients index page.
    - Search clients by name or email in clients index.
    - View clients show page (including their loans) via linked name in clients index.
    - Create best matched loan for client via section at the bottom of their show page.
    - Edit clients via edit button in clients index or client show page.
    - Delete a client via delete button on client edit page.
    - Manually create a loan for a client via button on show page.
2. **Lenders**
    - Create new lenders via lenders index page.
    - Search lenders by name in lenders index.
    - View lenders show page (including their loans) via linked name in lenders index.
    - Edit lenders via edit button in lenders index or lender show page.
    - Manually create a loan from a lender via button on show page.
3. **Loans**
    - Manually create a loan from loans index page.
    - Filter loans by status on loans index page.
    - Edit a loan via edit button on loans index page (only status may be changed).

---

## 🚦 Getting Started

### Prerequisites

- **Ruby** (2.7+)
- **Rails** (6.0+)
- **SQLite3**

### Installation

1. **Clone the repository**
    ```sh
    git clone <repository-url>
    cd clarify-capital
    ```

2. **Install dependencies**
    ```sh
    bundle install
    ```

3. **Set up the database**
    ```sh
    rails db:create
    rails db:migrate
    rails db:seed
    ```

4. **Running tests** 
    ```sh
    rails test
    ```

5. **Start the server**
    ```sh
    rails server
    ```

6. **Visit** [http://localhost:3000](http://localhost:3000) in your browser.

---

## 🧠 Matching Logic
- The loan-matching logic lives in `app/services/best_loan_creator.rb`.  
- It uses client credit score, lender minimum requirements, loan amount, and interest rate to select the best lender.

---

## 📄 Design Decisions
- Used a Rails service object (`BestLoanCreator`) to encapsulate business logic.
- Chose to write custom CSS manually for full control over layout and styles.

---

## 🚧 Future Improvements
- Integrate Devise and implement separate admin, client, and lender access levels.
- PDF uploads via ActiveStorage for client loan application documents.
- Dashboards for all user types (admin, client, lender).


---

## 📝 License

This project is open source and available under the MIT License.