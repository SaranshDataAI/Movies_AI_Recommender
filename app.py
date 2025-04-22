from flask import Flask, request, jsonify
import joblib
import pickle
import requests
from flask_cors import CORS

# Initialize Flask app
app = Flask(__name__)
CORS(app)

# Load models
movies = pickle.load(open('movies.pkl', 'rb'))
similarity = joblib.load(open('similarity_compressed.pkl', 'rb'))

# Replace with your actual TMDB API key
API_KEY = '711663af7d1c76be5a8b1f698d908a48'

# Helper function to fetch movie details from TMDB
def fetch_movie_details(movie_name):
    url = f"https://api.themoviedb.org/3/search/movie?api_key={API_KEY}&query={movie_name}"
    response = requests.get(url)
    data = response.json()

    if data['results']:
        movie = data['results'][0]
        return {
            'title': movie.get('title'),
            'poster_url': f"https://image.tmdb.org/t/p/w500{movie.get('poster_path')}" if movie.get('poster_path') else None,
            'overview': movie.get('overview'),
            'release_date': movie.get('release_date'),
            'rating': movie.get('vote_average')
        }
    return None

# Test route
@app.route('/')
def home():
    return "Flask is working!"

# Recommend route
@app.route('/recommend', methods=['POST'])
def recommend():
    data = request.get_json()
    movie = data.get('movie')

    try:
        index = movies[movies['title'].str.lower() == movie.lower()].index[0]
        distances = list(enumerate(similarity[index]))
        movies_list = sorted(distances, key=lambda x: x[1], reverse=True)[1:6]

        recommended = []
        for i in movies_list:
            title = movies.iloc[i[0]].title
            details = fetch_movie_details(title)
            if details:
                recommended.append(details)

        return jsonify({
            'movie': movie,
            'recommendations': recommended
        })
    except:
        return jsonify({'error': 'Movie not found'})

# Only runs locally
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
