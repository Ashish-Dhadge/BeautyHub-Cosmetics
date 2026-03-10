<%@ page import="java.util.*" %>
<%
Integer uid = (Integer) session.getAttribute("user_id");
String uname = (String) session.getAttribute("user_name");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>User Dashboard</title>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<style>
/* =========================================================
   1. GLOBAL & BODY STYLES
   ========================================================= */
body { margin: 0; font-family: 'Segoe UI', Arial, sans-serif; background: #f5f5f5; line-height: 1.6; }
i.fa-solid { margin-right: 8px; }

/* =========================================================
   2. HERO SECTION 
   ========================================================= */
.hero { height: 420px; background: url("images/hero.jpg") center/cover no-repeat; position: relative; display: flex; flex-direction: column; }
.hero-content { position: absolute; bottom: 60px; left: 60px; z-index: 2; }
.hero-content h1 { font-size: 48px; color: #4a2c2a; margin: 0; font-weight: 800; }
.hero-content p { font-size: 20px; color: #6d4c41; margin-top: 10px; }

/* =========================================================
   3. NAVIGATION BAR
   ========================================================= */
.navbar { background: rgba(255, 255, 255, 0.1); backdrop-filter: blur(5px); padding: 20px 40px; display: flex; align-items: center; justify-content: space-between; }
.nav-left { font-size: 20px; font-weight: bold; color: #4a2c2a; }
.nav-right { display: flex; gap: 20px; }
.nav-right a { color: #3e2723; text-decoration: none; font-weight: 600; transition: color 0.3s ease; }
.nav-right a:hover { color: #c2185b; text-decoration: underline; }

/* =========================================================
   4. SEARCH BAR
   ========================================================= */
.nav-search { display: flex; align-items: center; background: white; padding: 5px 10px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
.search-form { display: flex; align-items: center; gap: 5px; }
.nav-search input, .nav-search select { padding: 8px 12px; border: none; outline: none; background: transparent; }
.search-divider { width: 1px; height: 20px; background: #ddd; margin: 0 5px; }
.nav-search button { width: auto; padding: 8px 20px; background: #222; color: white; border: none; border-radius: 6px; font-weight: bold; cursor: pointer; transition: background 0.3s; }
.nav-search button:hover { background: #444; }
.clear-search { color: #999; text-decoration: none; font-size: 18px; margin: 0 10px; transition: color 0.2s; }
.clear-search:hover { color: #c2185b; }

/* =========================================================
   5. COMPACT PRODUCT GRID & CARDS
   ========================================================= */
.products { display: flex; flex-wrap: wrap; justify-content: center; padding: 40px 20px; gap: 20px; }
.card { background: white; width: 220px; padding: 15px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.08); text-align: center; transition: 0.3s; display: flex; flex-direction: column; justify-content: space-between; }
.card:hover { transform: translateY(-5px); }
.card img { width: 100%; height: 160px; object-fit: contain; margin-bottom: 12px; }
.card h4 { font-size: 16px; margin: 5px 0; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.card p { font-size: 13px; color: #777; margin: 0; }
.price { color: #c2185b; font-size: 1.1rem; font-weight: 800; margin: 10px 0; }
.price::before { content: "\20B9 "; }

.card-actions { display: flex; gap: 8px; margin-top: 10px; }
.card-actions form { flex: 1; }
.card-actions button { width: 100%; padding: 8px 2px; border: none; border-radius: 6px; font-weight: bold; cursor: pointer; color: white; font-size: 12px; }
.cart-btn { background: #c2185b; }
.buy-btn  { background: #1976d2; }
button:disabled { background: #bbb !important; cursor: not-allowed; width: 100%; padding: 8px; border-radius: 6px; border: none; }

/* =========================================================
   6. FOOTER & CHATBOT (SIMPLIFIED UI)
   ========================================================= */
/* ================= FOOTER (LAKME STYLE) ================= */
.footer {
    background: #111;              /* deeper luxury black */
    color: #bdbdbd;
    padding: 70px 10% 25px;
    margin-top: 80px;
    font-family: 'Segoe UI', Arial, sans-serif;
}

.footer-container {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
    gap: 50px;
}


.footer h2,
.footer h3,
.footer h4 {
    color: #ffffff;
    margin-bottom: 18px;
    font-weight: 700;
    letter-spacing: 0.5px;
}

.footer p {
    font-size: 14px;
    line-height: 1.7;
    color: #9e9e9e;
    margin: 0;
}

.footer a {
    display: block;
    color: #bdbdbd;
    text-decoration: none;
    font-size: 14px;
    margin-bottom: 10px;
    transition: all 0.3s ease;
}

.footer a:hover {
    color: #c2185b;                /* Lakmé pink */
    transform: translateX(4px);
}

.footer-bottom {
    text-align: center;
    margin-top: 50px;
    padding-top: 25px;
    border-top: 1px solid #2a2a2a;
    font-size: 13px;
    color: #888;
    letter-spacing: 0.5px;
}

/* SOCIAL ICONS */
.social-icons {
    display: flex;
    gap: 14px;
    margin-top: 10px;
}

.social-icons a {
    width: 40px;
    height: 40px;
    background: #1f1f1f;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #bdbdbd;
    font-size: 16px;
    transition: all 0.3s ease;
}

.social-icons a:hover {
    background: #c2185b;
    color: #fff;
    transform: translateY(-4px);
}


#chatbot-btn { 
    position: fixed; bottom: 30px; right: 30px; 
    width: 65px; height: 65px; 
    background: #c2185b; color: white; 
    font-size: 28px; border-radius: 50%; 
    display: flex; align-items: center; justify-content: center; 
    cursor: pointer; z-index: 1000000; 
    box-shadow: 0 6px 20px rgba(194, 24, 91, 0.4); 
}
#chatbot-btn i { margin: 0 !important; }

#chatbot-box { 
    position: fixed; bottom: 110px; right: 30px; 
    width: 380px; height: 500px; 
    background: white; border-radius: 15px; 
    box-shadow: 0 10px 30px rgba(0,0,0,0.2); 
    display: none; flex-direction: column; 
    overflow: hidden; z-index: 1000000; 
    border: 1px solid #eee; 
    transition: all 0.2s ease-in-out; 
}

/* FULLSCREEN CLASS */
#chatbot-box.fullscreen {
    width: 100vw !important;
    height: 100vh !important;
    bottom: 0 !important;
    right: 0 !important;
    border-radius: 0 !important;
}

#chatbot-header { 
    background: #c2185b; color: white; 
    padding: 12px 20px; font-weight: bold; 
    display: flex; justify-content: space-between; align-items: center; 
    font-size: 16px; 
}

.header-actions { display: flex; gap: 8px; align-items: center; }
.header-actions button { 
    background: rgba(255, 255, 255, 0.2) !important; 
    color: white !important; border: none !important; border-radius: 4px; 
    width: 30px; height: 30px; 
    cursor: pointer; display: flex; align-items: center; justify-content: center; 
}
.header-actions button:hover { background: rgba(255, 255, 255, 0.4) !important; }

#chatbot-messages { flex: 1; padding: 15px; overflow-y: auto; background: #fff; display: flex; flex-direction: column; gap: 10px; scroll-behavior: smooth; }
.msg-bubble { padding: 10px 15px; border-radius: 12px; max-width: 80%; font-size: 14px; line-height: 1.4; position: relative; word-wrap: break-word; }
.bot-msg { align-self: flex-start; background: #f1f1f1; color: #333; border-bottom-left-radius: 2px; }
.user-msg { align-self: flex-end; background: #c2185b; color: white; border-bottom-right-radius: 2px; text-align: left; }

#chatbot-input { display: flex; padding: 15px; background: #fff; border-top: 1px solid #eee; gap: 8px; }
#chatbot-input input { flex: 1; padding: 10px 15px; border: 1px solid #ddd; border-radius: 25px; outline: none; font-size: 14px; }
#chatbot-input button { width: 40px; height: 40px; border-radius: 50%; background: #c2185b; color: white; border: none; cursor: pointer; display: flex; align-items: center; justify-content: center; }
</style>
</head>

<body>

<div class="hero">
    <div class="navbar">
        <div class="nav-left">
        <% if(uid != null){ %>
            Welcome, <%= uname %>
        <% } else { %>
            Welcome to Cosmetic Store
        <% } %>
        </div>

        <div class="nav-search">
            <form action="ProductServlet" method="get" class="search-form">
                <input type="hidden" name="filter" value="yes">
                <input type="text" name="search" placeholder="Search product..." value="<%= request.getParameter("search")!=null?request.getParameter("search"):"" %>">
                
                <% if(request.getParameter("search")!=null && !request.getParameter("search").isEmpty()) { %>
                    <a href="ProductServlet" class="clear-search" title="Clear Search">
                        <i class="fa-solid fa-circle-xmark"></i>
                    </a>
                <% } %>

                <div class="search-divider"></div>
                
                <select name="category">
                    <option value="all">All Categories</option>
                    <%
                        String selectedCat = request.getParameter("category");
                        List<Map<String,String>> categories =
                            (List<Map<String,String>>)request.getAttribute("categories");
                        if(categories!=null){
                            for(Map<String,String> c:categories){
                    %>
                    <option value="<%= c.get("id") %>"
                        <%= c.get("id").equals(selectedCat)?"selected":"" %>>
                        <%= c.get("name") %>
                    </option>
                    <% } } %>
                </select>

                <button type="submit">
                    <i class="fa-solid fa-magnifying-glass"></i> Search
                </button>
            </form>
        </div>

        <div class="nav-right">
        <% if(uid == null){ %>
            <a href="login.jsp"><i class="fa-solid fa-right-to-bracket"></i> Login</a>
            <a href="register.jsp"><i class="fa-solid fa-user-plus"></i> Register</a>
        <% } else { %>
            <a href="ViewCartServlet">
                <i class="fa-solid fa-cart-shopping"></i>
                My Cart (<%= request.getAttribute("cartCount")==null?0:request.getAttribute("cartCount") %>)
            </a>
            <a href="UserProfileServlet"><i class="fa-solid fa-user"></i> My Profile</a>
            <a href="MyOrdersServlet"><i class="fa-solid fa-box"></i> My Orders</a>
            <a href="LogoutServlet"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
        <% } %>
        </div>
    </div>

    <div class="hero-content">
        <h1>Discover Your Beauty</h1>
        <p>Premium cosmetic products curated for you</p>
    </div>
</div>

<div class="products">
<%
List<Map<String,String>> products =
    (List<Map<String,String>>)request.getAttribute("products");
if(products!=null){
for(Map<String,String> p:products){
%>
<div class="card">
    <a href="ProductDetailsServlet?id=<%= p.get("id") %>"
       style="text-decoration:none;color:inherit;display:block;">

        <!-- ? FIXED IMAGE PATH -->
        <img src="images/products/<%= p.get("image") %>">

        <h4><%= p.get("name") %></h4>
        <p><%= p.get("brand") %></p>
        <p class="price"><%= p.get("price") %></p>
    </a>

    <div class="card-actions">
        <% if(Integer.parseInt(p.get("quantity"))>0){ %>
            <form action="AddToCartServlet" method="post" onsubmit="return checkLogin()">
                <input type="hidden" name="product_id" value="<%= p.get("id") %>">
                <button class="cart-btn" title="Add to Cart">
                    <i class="fa-solid fa-cart-shopping"></i>
                </button>
            </form>

            <form action="BuyNowServlet" method="post" onsubmit="return checkLogin()">
                <input type="hidden" name="product_id" value="<%= p.get("id") %>">
                <button class="buy-btn">Buy Now</button>
            </form>
        <% } else { %>
            <button disabled>Out of Stock</button>
        <% } %>
    </div>
</div>
<% } } %>
</div>

<%
List<Map<String,String>> recommended =
    (List<Map<String,String>>)request.getAttribute("recommendedProducts");
if(recommended!=null && !recommended.isEmpty()){
%>
<h2 style="text-align:center;color:#c2185b;margin-top:40px;">
    Recommended For You
</h2>

<div class="products">
<% for(Map<String,String> p:recommended){ %>
<div class="card">
    <a href="ProductDetailsServlet?id=<%= p.get("id") %>"
       style="text-decoration:none;color:inherit;display:block;">

        <!-- ? FIXED IMAGE PATH -->
        <img src="images/products/<%= p.get("image") %>">

        <h4><%= p.get("name") %></h4>
        <p><%= p.get("brand") %></p>
        <p class="price"><%= p.get("price") %></p>
    </a>

    <div class="card-actions">
        <% if(Integer.parseInt(p.get("quantity"))>0){ %>
            <form action="AddToCartServlet" method="post">
                <input type="hidden" name="product_id" value="<%= p.get("id") %>">
                <button class="cart-btn" title="Add to Cart">
                    <i class="fa-solid fa-cart-shopping"></i>
                </button>
            </form>

            <form action="BuyNowServlet" method="post">
                <input type="hidden" name="product_id" value="<%= p.get("id") %>">
                <button class="buy-btn">Buy Now</button>
            </form>
        <% } else { %>
            <button disabled>Out of Stock</button>
        <% } %>
    </div>
</div>
<% } %>
</div>
<% } %>

<!-- ================= FOOTER ================= -->
<div class="footer">
    <div class="footer-container">

        <!-- BRAND -->
        <div class="footer-col">
            <h2 class="footer-brand">Cosmetic Store</h2>
            <p>
                Discover premium beauty & skincare products curated just for you.
                Inspired by elegance, trusted by thousands.
            </p>
        </div>

        <!-- SHOP -->
        <div class="footer-col">
            <h4>Shop</h4>
            <a href="ProductServlet">All Products</a>
            <a href="ProductServlet?category=makeup">Makeup</a>
            <a href="ProductServlet?category=skincare">Skincare</a>
            <a href="ProductServlet?category=haircare">Hair Care</a>
        </div>

        <!-- ACCOUNT -->
        <div class="footer-col">
            <h4>My Account</h4>
            <a href="MyOrdersServlet">My Orders</a>
            <a href="ViewCartServlet">My Cart</a>
            <a href="UserProfileServlet">Profile</a>
        </div>

        <!-- HELP -->
        <div class="footer-col">
            <h4>Help</h4>
            <a href="faq.jsp">FAQs</a>
            <a href="shipping.jsp">Shipping & Delivery</a>
            <a href="returns.jsp">Returns & Refunds</a>
            <a href="contact.jsp">Contact Us</a>
        </div>

    </div>

    <div class="footer-bottom">
        © 2026 Cosmetic Store ? Inspired by Lakmé
    </div>
</div>



<div id="chatbot-btn" onclick="toggleChat()">
    <i class="fa-solid fa-comment-dots"></i>
</div>

<div id="chatbot-box">
    <div id="chatbot-header">
        <span><i class="fa-solid fa-robot"></i> Beauty Assistant</span>
        <div class="header-actions">
            <button onclick="toggleFullScreen()" title="Full Screen">
                <i class="fa-solid fa-expand" id="screen-icon"></i>
            </button>
            <button onclick="toggleChat()" title="Close">
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>
    </div>
    <div id="chatbot-messages"></div>
    <div id="chatbot-input">
        <input type="text" id="userMsg" placeholder="Ask about skincare..." onkeydown="if(event.key === 'Enter') sendMsg()">
        <button onclick="sendMsg()"><i class="fa-solid fa-paper-plane"></i></button>
    </div>
</div>

<script>
window.onload = function() {
    appendMessage("Beauty Assistant", "Hello! I am your Beauty Assistant. How can I help you with your skincare or makeup routine today?");
};

function toggleChat() {
    const chatBox = document.getElementById("chatbot-box");
    // Ensure we reset to normal size when closing/opening
    chatBox.classList.remove("fullscreen");
    document.getElementById("screen-icon").className = "fa-solid fa-expand";
    
    chatBox.style.display = (chatBox.style.display === "none" || chatBox.style.display === "") ? "flex" : "none";
}

function toggleFullScreen() {
    const chatBox = document.getElementById("chatbot-box");
    const icon = document.getElementById("screen-icon");
    chatBox.classList.toggle("fullscreen");
    
    if (chatBox.classList.contains("fullscreen")) {
        icon.className = "fa-solid fa-compress";
    } else {
        icon.className = "fa-solid fa-expand";
    }
}

function sendMsg() {
    const inputField = document.getElementById("userMsg");
    const userText = inputField.value.trim();
    if (userText === "") return;

    appendMessage("You", userText);
    inputField.value = ""; 

    const messages = document.getElementById("chatbot-messages");
    const typing = document.createElement("div");
    typing.id = "bot-loading";
    typing.style.fontSize = "12px";
    typing.style.color = "#999";
    typing.innerHTML = "<em>Beauty Assistant is thinking...</em>";
    messages.appendChild(typing);
    messages.scrollTop = messages.scrollHeight;

    fetch('ChatbotServlet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'message=' + encodeURIComponent(userText)
    })
    .then(res => res.json())
    .then(data => {
        const loader = document.getElementById("bot-loading");
        if(loader) loader.remove();
        
        if (data.candidates && data.candidates[0].content) {
            let botText = data.candidates[0].content.parts[0].text;
            botText = botText.replace(/\*\*/g, "").replace(/###/g, "").trim();
            appendMessage("Beauty Assistant", botText);
        } else if (data.error) {
            appendMessage("Error", data.error.message);
        }
    })
    .catch(err => {
        const loader = document.getElementById("bot-loading");
        if(loader) loader.remove();
        appendMessage("System", "Could not reach the server.");
    });
}

function appendMessage(sender, text) {
    const messages = document.getElementById("chatbot-messages");
    const div = document.createElement("div");
    const isBot = (sender !== "You");
    div.className = isBot ? "msg-bubble bot-msg" : "msg-bubble user-msg";
    div.innerHTML = "<strong>" + sender + "</strong><br>" + text;
    messages.appendChild(div);
    messages.scrollTop = messages.scrollHeight;
}

function checkLogin(){
    var loggedIn = <%= (uid != null) ? "true" : "false" %>;

    if(!loggedIn){
        document.getElementById("loginModal").style.display = "flex";
        return false;
    }
    return true;
}

</script>
</body>
</html>