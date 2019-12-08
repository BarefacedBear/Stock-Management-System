# Importing libraries
from flask import Flask, render_template, flash, redirect, url_for, session, logging, request
from flask_mysqldb import MySQL
from flask_toastr import Toastr
from wtforms import Form, StringField, PasswordField, SelectField, DecimalField, IntegerField, validators
from passlib.hash import sha256_crypt
from functools import wraps

app = Flask(__name__) # Initializing the app
app.secret_key = "d8a55b32208aad544062886fc5342c35da34ae3a5af33042" #Generated Secret Key

#Configuring database
app.config['MYSQL_HOST'] = '127.0.0.1'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = '8420'
app.config['MYSQL_DB'] = 'stock_management'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'

mysql = MySQL(app)

# User Registration
class Registration(Form):
	reg_name = StringField('Name',[validators.Length(min=5,max=20), validators.DataRequired()])
	reg_email = StringField('Email',[validators.DataRequired()])
	reg_category = SelectField(label='Category', choices=[('COMPANY','COMPANY'),('DISTRIBUTOR','DISTRIBUTOR'),('OUTLET','OUTLET')])
	reg_password = PasswordField('Password',[validators.Length(min=5,max=15), validators.DataRequired(), validators.EqualTo('reg_confirm', message='Password do not match')])
	reg_confirm = PasswordField('Confirm Password')

@app.route('/', methods=['GET','POST']) # Decorator to create url routing, '/' = Home route
def register():
	form = Registration(request.form)
	if request.method == 'POST' and form.validate():
		reg_name = form.reg_name.data
		reg_email = form.reg_email.data
		reg_category = form.reg_category.data
		reg_password = sha256_crypt.encrypt(str(form.reg_password.data))

		cur = mysql.connection.cursor()
		if reg_category == 'COMPANY':
			cur.execute('INSERT INTO company_users(NAME,EMAIL,PASSWORD) VALUES (%s,%s,%s)',(reg_name,reg_email,reg_password))
		else:
			cur.execute('INSERT INTO registration(NAME,CATEGORY,EMAIL,PASSWORD) VALUES (%s,%s,%s,%s)',(reg_name,reg_category,reg_email,reg_password))
		mysql.connection.commit()
		cur.close()

		if reg_category == 'COMPANY':
			flash('Registration successfull !!','success')
		else:
			flash('Registration successfull !! Wait for confirmation...','success')
		return redirect(url_for('register'))
		
	return render_template('index.html',form=form)

# About
@app.route('/about')
def about():
	return render_template('about.html')

# User Login
@app.route('/login', methods=['POST'])
def login():
	flag = ''
	if request.method == 'POST':
		log_email = request.form['email']
		password_temp = request.form['password']
		category = request.form.get('category')
		cur = mysql.connection.cursor()
		if category == 'COMPANY':
			flag = 'C'
			result = cur.execute('SELECT * FROM company_users WHERE EMAIL=%s',[log_email])
		elif category == 'DISTRIBUTOR':
			flag = 'D'
			result = cur.execute('SELECT * FROM company_customers WHERE EMAIL=%s',[log_email])
		else:
			flag = 'O'
			result = cur.execute('SELECT * FROM company_customers WHERE EMAIL=%s',[log_email])

		if result>0:
			value = cur.fetchone()
			password = value['PASSWORD']
			if sha256_crypt.verify(password_temp,password):
				session['logged_in'] = True
				session['username'] = value['NAME'] # Retrieving username from database for session
				session['user_type'] = flag
				if session['user_type'] == 'C' or session['user_type'] == 'D':
					return redirect(url_for('pending_registration'))
				else:
					return redirect(url_for('buy_product'))
			else:
				form = Registration(request.form)
				return render_template('index.html', form=form, error='Incorrect Password')
			cur.close()
		else:
			form = Registration(request.form)
			return render_template('index.html', form=form, error='Email not found')

# Checking if session is logged in
def is_logged_in(f):
	@wraps(f)
	def wrap(*args, **kwargs):
		if 'logged_in' in session:
			return f(*args, **kwargs)
		else:
			flash('Unauthorized attempt, Please Login','danger')
			return redirect(url_for('register'))
	return wrap

# Logout
@app.route('/logout')
@is_logged_in
def logout():
	session.clear()
	return redirect(url_for('register'))

# Dashboard
# Pending user registration
@app.route('/dashboard/pending_registration')
@is_logged_in
def pending_registration():
	if session['user_type'] == 'C':
		cur = mysql.connection.cursor()
		result = cur.execute('SELECT * from registration')
		data = cur.fetchall()
		if result>0:
			return render_template('pending_registration.html', users=data)
		else:
			return render_template('pending_registration.html',msg='No Pending registration')
		cur.close()
	else:
		return redirect(url_for('registered_customers'))

# Company accepting users
@app.route('/accept/<string:id_val>',methods=['POST','GET'])
@is_logged_in
def accept(id_val):
	cur = mysql.connection.cursor()
	cur.execute('INSERT INTO company_customers(NAME,CATEGORY,EMAIL,PASSWORD) SELECT r.NAME,r.CATEGORY,r.EMAIL,r.PASSWORD FROM registration r WHERE r.ID=%s',(id_val))
	cur.execute('DELETE FROM registration WHERE ID=%s',(id_val))
	flash("Customer Registered Successfully !!","success")
	mysql.connection.commit()
	cur.close()
	return redirect(url_for('pending_registration'))

@app.route('/reject/<string:id_val>',methods=['POST','GET'])
@is_logged_in
def reject(id_val):
	cur = mysql.connection.cursor()
	if session['user_type'] == 'C':
		cur.execute('DELETE FROM company_warehouse WHERE cpID=%s',[id_val])
		flash("Product Removed from Warehouse !!","danger")
		mysql.connection.commit()
		return redirect(url_for('warehouse'))
	elif session['user_type'] == 'D':
		cur.execute('DELETE FROM distributor_warehouse WHERE dpID=%s',[id_val])
		flash("Product Removed from Warehouse !!","danger")
		mysql.connection.commit()
		return redirect(url_for('warehouse'))
	else:
		cur.execute('DELETE FROM outlet_warehouse WHERE opID=%s',[id_val])
		flash("Product Removed from Warehouse !!","danger")
		mysql.connection.commit()
		return redirect(url_for('warehouse'))

	if session['user_type'] == 'C':
		cur.execute('DELETE FROM registration WHERE ID=%s',(id_val))
		flash("Customer Rejected !!","danger")
		mysql.connection.commit()
		return redirect(url_for('pending_registration'))
	cur.close()

@app.route('/update',methods=['POST','GET'])
@is_logged_in
def update():
	if request.method == 'POST':
		cur = mysql.connection.cursor()
		if session['user_type'] == 'C':
			product_id = request.form['product_id']
			product_name = request.form['product_name']
			product_qty = request.form['product_qty']
			product_price = request.form['product_price']
			cur.execute('UPDATE company_warehouse SET PRODUCT_NAME=%s, QTY=%s, PRICE_PER_UNIT=%s WHERE cpID=%s',(product_name,product_qty,product_price,product_id))
			flash('Product Updated Successfully','warning')
		elif session['user_type'] == 'D':
			product_id = request.form['product_id']
			sell_price = request.form['sell_price']
			cur.execute('UPDATE distributor_warehouse SET SELL_PRICE=%s WHERE dpID=%s',(sell_price,product_id))
			flash('Sell Price Updated Successfully','warning')
		else:
			product_id = request.form['product_id']
			sell_price = request.form['sell_price']
			cur.execute('UPDATE outlet_warehouse SET SELL_PRICE=%s WHERE opID=%s',(sell_price,product_id))
			flash('Sell Price Updated Successfully','warning')
		mysql.connection.commit()
		return redirect(url_for('warehouse'))
		cur.close()
	return render_template('warehouse.html')

# Registered Customers
@app.route('/dashboard/registered_customers')
@is_logged_in
def registered_customers():
	cur = mysql.connection.cursor()
	if session['user_type'] == 'C':
		result = cur.execute('SELECT * from company_customers')
	else:
		result = cur.execute('SELECT * from company_customers WHERE CATEGORY="OUTLET"')
	data = cur.fetchall()
	if result>0:
		return render_template('registered_customer.html', customers=data)
	else:
		return render_template('registered_customer.html',msg='No customers')
	cur.close()

# Show Warehouse stocks
@app.route('/dashboard/warehouse', methods=['POST','GET'])
@is_logged_in
def warehouse():
	cur = mysql.connection.cursor()
	if session['user_type'] == 'C':
		result = cur.execute('SELECT * from company_warehouse')
		data = cur.fetchall()
		if result>0:
			return render_template('warehouse.html', stocks=data)
		else:
			return render_template('warehouse.html',msg='Stock Empty')
		cur.close()
	elif session['user_type'] == 'D':
		result = cur.execute('SELECT d.dpID,d.QTY,c.PRODUCT_NAME,d.COST_PRICE,d.SELL_PRICE FROM company_warehouse AS c INNER JOIN distributor_warehouse AS d ON d.cpID=c.cpID')
		data = cur.fetchall()
		if result>0:
			return render_template('warehouse.html', stocks=data)
		else:
			return render_template('warehouse.html',msg='Stock Empty')
		cur.close()
	else:
		result = cur.execute('select c.PRODUCT_NAME,o.opID,o.QTY,o.COST_PRICE,o.SELL_PRICE from outlet_warehouse o INNER JOIN distributor_warehouse d ON o.dpID=d.dpID inner join company_warehouse c ON c.cpID=d.cpID')
		data = cur.fetchall()
		if result>0:
			return render_template('warehouse.html', stocks=data)
		else:
			return render_template('warehouse.html',msg='Stock Empty')
		cur.close()

# Add stocks to warehouse
@app.route('/add_warehouse',methods=['POST','GET'])
@is_logged_in
def add_warehouse():
	if request.method == 'POST':
		product_name = request.form['product_name']
		product_qty = request.form['product_qty']
		product_price = request.form['product_price']
		cur = mysql.connection.cursor()
		cur.execute('INSERT INTO company_warehouse(PRODUCT_NAME,QTY,PRICE_PER_UNIT) VALUES(%s,%s,%s)',(product_name,product_qty,product_price))
		mysql.connection.commit()
		flash('Product Added !!','success')
		return redirect(url_for('warehouse'))
		cur.close()
	return render_template('warehouse.html')

# Buy Products
@app.route('/dashboard/buy-product')
@is_logged_in
def buy_product():
	cur = mysql.connection.cursor()
	company = cur.execute('SELECT * from company_warehouse')
	data1 = cur.fetchall()
	distributor = cur.execute('SELECT dpID,d.QTY,SELL_PRICE,PRODUCT_NAME from distributor_warehouse d INNER JOIN company_warehouse c ON d.cpID=c.cpID')
	data2 = cur.fetchall()
	if company>0:
		return render_template('buy_product.html', cstocks=data1,dstocks=data2)
	elif distributor>0:
		return render_template('buy_product.html', cstocks=data1,dstocks=data2)
	else:
		return render_template('buy_product.html',msg='Stock Empty')
	cur.close()

@app.route('/buy/<string:id_val>', methods=['POST','GET'])
@is_logged_in
def buy(id_val):
	if request.method == 'POST':
		buy_amt = request.form['buy_amt']
		sell_price = request.form['sell_price']
		cur = mysql.connection.cursor()
		if session['user_type'] == 'D':
			result = cur.execute('SELECT * from company_warehouse WHERE cpID=%s',[id_val])
			value = cur.fetchone()
			cur.execute('SELECT * FROM distributor_warehouse WHERE cpID=%s',[id_val])
			temp = cur.fetchone()
			if temp != None:
				cur.execute('UPDATE company_warehouse SET QTY=%s WHERE cpID=%s',(str(int(value['QTY']) - int(buy_amt)),id_val))
				cur.execute('UPDATE distributor_warehouse SET QTY=%s WHERE cpID=%s',(str(int(buy_amt)+int(temp['QTY'])),id_val))
			else:
				cur.execute('UPDATE company_warehouse SET QTY=%s WHERE cpID=%s',(str(int(value['QTY']) - int(buy_amt)),id_val))
				cur.execute('INSERT INTO distributor_warehouse(cpID,QTY,COST_PRICE,SELL_PRICE) VALUES(%s,%s,%s,%s)',(id_val,buy_amt,value['PRICE_PER_UNIT'],sell_price))
		else:
			result = cur.execute('SELECT * from distributor_warehouse WHERE dpID=%s',[id_val])
			value = cur.fetchone()
			cur.execute('SELECT * FROM outlet_warehouse WHERE dpID=%s',[id_val])
			temp = cur.fetchone()
			if temp != None:
				cur.execute('UPDATE distributor_warehouse SET QTY=%s WHERE dpID=%s',(str(int(value['QTY']) - int(buy_amt)),id_val))
				cur.execute('UPDATE outlet_warehouse SET QTY=%s WHERE dpID=%s',(str(int(buy_amt)+int(temp['QTY'])),id_val))
			else:
				cur.execute('UPDATE distributor_warehouse SET QTY=%s WHERE dpID=%s',(str(int(value['QTY']) - int(buy_amt)),id_val))
				cur.execute('INSERT INTO outlet_warehouse(dpID,QTY,COST_PRICE,SELL_PRICE) VALUES(%s,%s,%s,%s)',(id_val,buy_amt,value['SELL_PRICE'],sell_price))
		mysql.connection.commit()
		flash('Buyed Successfully','success')
		return redirect(url_for('buy_product'))
		cur.close()
	return render_template('buy_product.html')

if __name__ == '__main__':
	app.run(debug = True)