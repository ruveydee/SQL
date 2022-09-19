classDiagram
      
class product {
    prod_id
          prod_name
          quantity
          
}
        
class Prod_Comp {
    comp_id
          prod_id
          quantitiy_comp
          
}
        
class Component {
    comp_id
          comp_name
          description
          quantitiy_comp
          
}
        
class Supplier {
    is_active
          supp_country
          supp_id
          supp_location
          supp_name
          
}
        
class comp_supp {
    comp_id
          order_date
          quantitive
          supp_id
          
}
        
      Prod_Comp --|> Component: comp_id
            Prod_Comp --|> product: prod_id
            comp_supp --|> Component: comp_id
            comp_supp --|> Supplier: supp_id
            
      