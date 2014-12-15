class Admin < User


        def event.search(search)
    	if search
    		find(:all, :conditions => ['event_name LIKE ?', "%#{search}%"])
    	else
    		
    	end
    end
end
